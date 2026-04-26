#!/usr/bin/env python3
import json, sys, re

data = json.load(sys.stdin)
tool = data.get('tool_name', '')
inp = data.get('tool_input', {})

# Filename patterns for secret/credential files
FILE_PATTERNS = [
    r'(^|[/\\])\.env$',
    r'\.pem$',
    r'\.key$',
    r'\.cert$',
    r'(^|[/\\])secrets\.json$',
    r'(^|[/\\])config\.json$',
    r'(^|[/\\])key\.properties$',
    r'\.jks$',
    r'\.keystore$',
    r'(^|[/\\])local\.properties$',
    r'(^|[/\\])google-services\.json$',
    r'\.p8$',
    r'\.p12$',
    r'\.mobileprovision$',
    r'(^|[/\\])GoogleService-Info\.plist$',
]

# Looser patterns for matching inside a bash command string
BASH_PATTERNS = [
    r'(?<![.\w])\.env(?![.\w])',
    r'\w*\.pem\b',
    r'\w*\.key\b',
    r'\w*\.cert\b',
    r'\bsecrets\.json\b',
    r'\bconfig\.json\b',
    r'\bkey\.properties\b',
    r'\w*\.jks\b',
    r'\w*\.keystore\b',
    r'\blocal\.properties\b',
    r'\bgoogle-services\.json\b',
    r'\w*\.p8\b',
    r'\w*\.p12\b',
    r'\w*\.mobileprovision\b',
    r'\bGoogleService-Info\.plist\b',
]

def matches(s, patterns):
    return next((p for p in patterns if re.search(p, s)), None)

if tool in ('Read', 'Edit', 'Write', 'MultiEdit'):
    target = inp.get('file_path') or inp.get('path') or ''
    matched_pattern = matches(target, FILE_PATTERNS) if target else None
elif tool == 'Bash':
    target = inp.get('command', '')
    matched_pattern = matches(target, BASH_PATTERNS) if target else None
else:
    matched_pattern = None

if matched_pattern:
    print(json.dumps({
        'hookSpecificOutput': {
            'hookEventName': 'PreToolUse',
            'permissionDecision': 'deny',
            'permissionDecisionReason': (
                f'BLOCKED: Access to secret/credential file denied.\n'
                f'Matched pattern in: {target[:120]}'
            ),
        }
    }))
    sys.exit(2)
