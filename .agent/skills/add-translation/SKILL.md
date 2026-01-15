---
name: Translation Manager
description: Safely adds new translation keys to both English and French localization files.
---

# Translation Manager

Use this skill when the user asks to "add a translation" or "add text".

## Process

1.  **Read Files**: Read content of:
    - `assets/translations/en.json`
    - `assets/translations/fr.json`

2.  **Generate Keys**:
    - If the user provides a key (e.g., `download_error`), use it.
    - If not, convert the English text to `snake_case` (e.g., "Download Error" -> `download_error`).

3.  **Insert Content**:
    - Add the new key-value pair to `en.json`.
    - Add the corresponding French translation to `fr.json`. If you don't know the French translation, use a placeholder or ask the user, but typically you should attempt a best-effort translation.

4.  **Formatting**:
    - Ensure valid JSON syntax (commas, quotes).
    - Maintain consistent indentation (2 spaces).

5.  **Usage**:
    - Remind the user to use the key in Dart code as `"key_name".tr()`.
