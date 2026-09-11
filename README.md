# INVOTATION V27

Based directly on V26. This update only revises the printable Invoice/Penawaran table behavior requested by the user.

## V27 changes
- Keeps multiline item descriptions exactly as in V26.
- Printable Invoice and Penawaran now render only item rows that actually contain a description. No automatic empty rows are added.
- Total/Grand Total is now part of the same table `tfoot`, so the amount box is exactly aligned with the `Jumlah` column and table borders close cleanly.
- Existing Discount / PPN support is retained; when used, Subtotal, Discount and PPN stay aligned to the same final amount column before Grand Total.
- All other V26 features, UI, Sync, Supabase, Backup, Settings, numbering, validation, PDF/Print, custom controls and local-first behavior are unchanged.

## Deploy
Upload/replace the contents of this ZIP at the root of the existing GitHub repository, then let Vercel deploy normally.

No Supabase migration is required.
