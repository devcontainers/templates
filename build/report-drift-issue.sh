#!/usr/bin/env bash
#
# Creates a single tracking issue describing the drift between the templates in this repo
# and the images published by devcontainers/images, then assigns it to the GitHub Copilot
# coding agent (or a configurable GitHub user) so it can prepare the fix. A new issue is
# only created when a similar tracking issue isn't already open.
#
# Input:  a plain-text report produced by `npx tsx build/check-image-tags.ts <images>`
#         (ANSI colour codes already stripped).
# Usage:  build/report-drift-issue.sh <report-file>
# Env:    GH_TOKEN / GITHUB_TOKEN  - token with `issues: write`
#         GITHUB_REPOSITORY        - owner/name (defaults to devcontainers/templates)
#         ASSIGNEE_LOGIN           - optional GitHub username to assign the issue to.
#                                    When empty, defaults to the Copilot coding agent.
#                                    Assignment is best-effort: if it fails, a warning is
#                                    emitted and the script still exits 0 (issue is left
#                                    unassigned but creation is never affected).
set -euo pipefail

REPORT_FILE="${1:?Usage: report-drift-issue.sh <report-file>}"
REPO="${GITHUB_REPOSITORY:-devcontainers/templates}"
OWNER="${REPO%%/*}"
NAME="${REPO##*/}"
LABEL="automated-image-sync"
TITLE="Sync template image variants with devcontainers/images"
# Login of the Copilot coding agent actor (shows up as "Copilot" in the UI). Used as the
# default assignee when ASSIGNEE_LOGIN is not provided.
COPILOT_LOGIN="copilot-swe-agent"
# Optional override: assign the issue to this GitHub user instead of the Copilot agent.
ASSIGNEE_LOGIN="${ASSIGNEE_LOGIN:-}"
TARGET_ASSIGNEE="${ASSIGNEE_LOGIN:-$COPILOT_LOGIN}"

# --- Extract the actionable signals from the report ---------------------------------
missing="$(grep -E '^[[:space:]]*MISSING' "$REPORT_FILE" | sed -E 's/^[[:space:]]*MISSING[[:space:]]+//' | sort -u || true)"
unused="$(grep -E '^[[:space:]]*UNUSED' "$REPORT_FILE" | sed -E 's/^[[:space:]]*UNUSED[[:space:]]+//' | sort -u || true)"

if [ -z "$missing" ] && [ -z "$unused" ]; then
    echo "No drift detected; nothing to do."
    exit 0
fi

# --- Build the issue body ------------------------------------------------------------
body_file="$(mktemp)"
{
    echo "## Templates ↔ images drift detected"
    echo
    echo "The scheduled **Compare Templates against Images** workflow detected differences"
    echo "between the image tags referenced by templates in this repo and the tags published"
    echo "by [devcontainers/images](https://github.com/devcontainers/images)."
    echo
    echo "Please follow the rules in [AGENTS.md](https://github.com/${REPO}/blob/main/AGENTS.md)"
    echo "(section *“Keeping templates in sync with devcontainers/images”*) to update the"
    echo "affected templates, bump each edited template's \`version\`, and validate with"
    echo "\`npx tsx build/check-image-tags.ts <images-repo>\` until there are **no MISSING tags**."
    echo

    if [ -n "$missing" ]; then
        echo "### ❌ MISSING — referenced by templates but no longer published"
        echo "Remove these variants from the matching template's \`options.imageVariant.proposals\`"
        echo "(update \`default\` if it pointed at one of them)."
        echo
        echo '```'
        echo "$missing"
        echo '```'
        echo
    fi

    if [ -n "$unused" ]; then
        echo "### ⚠️ UNUSED — published but not referenced by any template"
        echo "Most of these are **intentional** (floating tags, OS-only tags, aliases)."
        echo "Only add an entry if it is a genuinely new \`{version}-{os}\` variant that matches a"
        echo "template's existing convention (cross-check the image's \`manifest.json\` \`variants\`)."
        echo
        echo "<details><summary>Show $(printf '%s\n' "$unused" | wc -l | tr -d ' ') unused tags</summary>"
        echo
        echo '```'
        echo "$unused"
        echo '```'
        echo
        echo "</details>"
        echo
    fi

    echo "<details><summary>Full comparison report</summary>"
    echo
    echo '```'
    cat "$REPORT_FILE"
    echo '```'
    echo
    echo "</details>"
    echo
    echo "---"
    echo "_Generated automatically by \`.github/workflows/check-image-tags.yaml\`. A new issue is"
    echo "opened only when no similar tracking issue is already open._"
} >"$body_file"

# --- Ensure the tracking label exists ------------------------------------------------
gh label create "$LABEL" --repo "$REPO" \
    --color "1d76db" --description "Automated templates/images variant sync" 2>/dev/null || true

# --- Create a single open tracking issue (only if one isn't already open) ------------
existing="$(gh issue list --repo "$REPO" --state open --label "$LABEL" \
    --json number --jq '.[0].number // empty' || true)"

if [ -n "$existing" ]; then
    echo "An open tracking issue already exists (#${existing}); nothing to do."
    echo "Issue #${existing}: https://github.com/${REPO}/issues/${existing}"
    exit 0
fi

echo "Creating new tracking issue"
issue_url="$(gh issue create --repo "$REPO" --title "$TITLE" \
    --label "$LABEL" --body-file "$body_file")"
issue_number="${issue_url##*/}"
echo "Issue #${issue_number}: https://github.com/${REPO}/issues/${issue_number}"

# --- Assign the issue (best-effort) --------------------------------------------------
# Assign to the configured GitHub user, or the Copilot coding agent by default. The
# assignee (bot or user) must be assignable in the repo; it then appears as a suggested
# actor. Assignment is best-effort: the issue is already created above, so if the actor
# id can't be resolved or the assignment fails we warn and `exit 0` rather than error.
actor_id="$(gh api graphql -f owner="$OWNER" -f name="$NAME" -f query='
    query($owner:String!, $name:String!) {
        repository(owner:$owner, name:$name) {
            suggestedActors(capabilities:[CAN_BE_ASSIGNED], first:100) {
                nodes { login __typename ... on Bot { id } ... on User { id } }
            }
        }
    }' --jq ".data.repository.suggestedActors.nodes[] | select(.login==\"${TARGET_ASSIGNEE}\") | .id" || true)"

if [ -z "$actor_id" ]; then
    echo "::warning::'${TARGET_ASSIGNEE}' is not assignable in ${REPO}. Issue #${issue_number} left unassigned."
    exit 0
fi

issue_id="$(gh api graphql -f owner="$OWNER" -f name="$NAME" -F number="$issue_number" -f query='
    query($owner:String!, $name:String!, $number:Int!) {
        repository(owner:$owner, name:$name) { issue(number:$number) { id } }
    }' --jq '.data.repository.issue.id')"

if ! gh api graphql -f assignableId="$issue_id" -f actorId="$actor_id" -f query='
    mutation($assignableId:ID!, $actorId:ID!) {
        replaceActorsForAssignable(input:{assignableId:$assignableId, actorIds:[$actorId]}) {
            assignable { ... on Issue { number assignees(first:5){nodes{login}} } }
        }
    }' >/dev/null; then
    echo "::warning::Failed to assign issue #${issue_number} to '${TARGET_ASSIGNEE}'. Issue left unassigned."
    exit 0
fi

echo "Assigned issue #${issue_number} to '${TARGET_ASSIGNEE}'."

exit 0
