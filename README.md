# INVOTATION V28

Based directly on V27. This update only revises the printable Invoice/Penawaran table and Catatan formatting requested by the user.

## V28 changes
- Keeps multiline item descriptions exactly as in V27.
- Invoice and Penawaran show only actual item rows; no empty filler rows.
- Restores a continuous horizontal closing line below the final item row before Total/Grand Total.
- Harga, Jumlah, Subtotal, Discount, PPN and Total/Grand Total numeric amounts are right-aligned.
- Total/Grand Total remains aligned to the same final `Jumlah` column.
- Printable label `Notes:` is changed to `Catatan:`.
- Every non-empty line in Catatan is rendered as its own bullet point.
- All other V27 features, UI, Sync, Supabase, Backup, Settings, numbering, validation, PDF/Print, custom controls and local-first behavior are unchanged.

## Deploy
Upload/replace the contents of this ZIP at the root of the existing GitHub repository, then let Vercel deploy normally.

No Supabase migration is required.
