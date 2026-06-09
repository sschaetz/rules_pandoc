#!/usr/bin/env bash
# Emits stable workspace-status keys. STABLE_ keys only re-trigger dependent
# actions when their value changes (good for a commit SHA).
echo "STABLE_GIT_SHA $(git rev-parse --short HEAD 2>/dev/null || echo unknown)"
