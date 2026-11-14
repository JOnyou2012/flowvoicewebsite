# flowvoicewebsite
## Warm editorial edition

Live: https://flowvoice.polqrized.com

The updated visual theme follows the portfolio's warm FlowVoice preview: cream paper, pink waveform, expressive typography and a floating thought card. Product explanations, the Mac interface walkthrough, download/release links, Supabase sign-in/signup, account management and password recovery retain their existing logic. The waveform and thought card are illustrations, not a web microphone recorder.

Run `python build.py` to package the explicit public-file allowlist into `dist`. `npx wrangler deploy` uses `wrangler.json` to build and publish on the custom domain. The base URL serves the complete landing page directly. The existing Supabase publishable configuration is retained; email confirmation and password-reset redirects for this hostname must be allowed in the Supabase project's URL settings. No real accounts were created or changed during validation.
