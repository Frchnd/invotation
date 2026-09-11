# INVOTATION V26

Full deploy package based directly on V25, with only the requested revisions.

## V26 changes
- Keeps multiline item descriptions: Enter creates a new line and the line breaks remain in Preview / Print / PDF.
- Removes the visible Template Editor feature.
- Removes DOCX export; Preview now has direct **Export PDF** and **Print** actions.
- Restores the top navigation to four stable destinations: Dokumen, Pengaturan, Backup, Sync. Mobile uses four equal tabs so the navigation does not keep growing horizontally.
- Rebuilds the printable Penawaran and Invoice layout to follow the supplied reference PDFs: Arial typography, company header + logo placement, double divider, title, metadata/recipient layout, compact 8-row table, Terbilang, Payment Information for Invoice, Notes, closing paragraph, and right-side signature block.
- Existing QR Sync, Supabase configuration, Backup, Settings, numbering, validation, custom dropdowns/date picker, local-first behavior, image optimization, PDF/Print flow, and other completed features are retained.

## Deploy
Upload/replace the contents of this ZIP at the root of the existing GitHub repository, then let Vercel deploy normally.

`cloud-config.js` is already configured for the current INVOTATION Supabase project. Never replace it with a secret/service_role key.

## Supabase
No database migration is required for V26. `supabase-schema.sql` is included only as the current recovery/reference schema. Do not rerun it on the existing production project unless a schema repair is actually needed.
