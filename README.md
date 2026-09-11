# INVOTATION V25

Full deploy package for the current INVOTATION production app.

## V25 changes
- Adds a dedicated **Template** page, separate from document Preview.
- Penawaran and Invoice have separate templates.
- Document sections can be reordered by drag-and-drop or arrow buttons.
- Per-section controls: font size, bold, italic, underline, alignment, and top/bottom spacing.
- Adds complete signature blocks: salutation/label, company/party name, signature/stamp image, signer name, role, and left/center/right position.
- Up to 3 signature blocks per template.
- Saved documents store a template snapshot so later template edits do not redesign old documents.
- Item description remains multiline: Enter creates a new line and line breaks are preserved in Preview / Print-PDF / DOCX.
- V23 UI polish and V22 QR Sync are retained.

## Deploy
Upload/replace the contents of this ZIP at the root of the existing GitHub repository, then let Vercel deploy normally.

`cloud-config.js` in this package is already configured for the current INVOTATION Supabase project. Never replace it with a secret/service_role key.

## Supabase
No database migration is required for V25. `supabase-schema.sql` is included only as the current recovery/reference schema. Do not rerun it on the existing production project unless a schema repair is actually needed.
