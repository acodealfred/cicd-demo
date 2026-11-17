#!/usr/bin/env bash
# Prints a Markdown summary of an .xcresult bundle, for $GITHUB_STEP_SUMMARY.
# Usage: scripts/test-summary.sh path/to/TestResults.xcresult
set -euo pipefail

RESULT_BUNDLE="${1:?usage: $0 <path to .xcresult>}"

if [[ ! -d "$RESULT_BUNDLE" ]]; then
    echo "## 🧪 Test results"
    echo
    echo "⚠️ No result bundle at \`$RESULT_BUNDLE\`. The build probably failed before tests ran; check the build step log."
    exit 0
fi

SUMMARY_JSON="$(xcrun xcresulttool get test-results summary --path "$RESULT_BUNDLE" --compact)"

# Header, totals and devices. Device-level counts are per test case,
# so parameterized tests show each argument set separately.
jq -r '
    def icon: if . == "Passed" then "✅" elif . == "Failed" then "❌" else "⚠️" end;
    def esc: tostring | gsub("\\|"; "\\|");
    "## 🧪 Test results: \(.result | icon) \(.result)",
    "",
    "| Tests | Passed | Failed | Skipped | Expected failures | Duration |",
    "|---|---|---|---|---|---|",
    "| \(.totalTestCount) | \(.passedTests) | \(.failedTests) | \(.skippedTests) | \(.expectedFailures) | \(((.finishTime - .startTime) * 10 | round) / 10)s |",
    "",
    "| Device | OS | Passed cases | Failed cases | Skipped cases |",
    "|---|---|---|---|---|",
    (.devicesAndConfigurations[] |
        "| \(.device.deviceName | esc) | \(.device.platform) \(.device.osVersion) | \(.passedTests) | \(.failedTests) | \(.skippedTests) |")
' <<< "$SUMMARY_JSON"

# One section per failure with the full message, which can span several lines.
jq -r '
    if (.testFailures | length) > 0 then
        "",
        "### ❌ Failures",
        (.testFailures[] |
            "",
            "**\(.testName)**  ",
            "`\(.targetName)` › `\(.testIdentifierString)`",
            "",
            "```",
            .failureText,
            "```")
    else empty end
' <<< "$SUMMARY_JSON"
