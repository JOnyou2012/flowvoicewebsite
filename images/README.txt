Put public images here (logos, email headers, etc.).

Examples:
  images/logo-email.png   → https://YOUR_DOMAIN/images/logo-email.png

Supabase "Confirm signup" email img src:
  {{ .SiteURL }}/images/logo-email.png

Local preview (run.sh):
  http://localhost:8000/images/logo-email.png

Tip: Use PNG or JPG for email (many clients block SVG). ~2× size for retina is fine.

Signup OTP: paste supabase_email_confirm_signup_FRAGMENT.html into
Supabase → Auth → Email templates → Confirm signup body.
If the email shows literal braces, read supabase_SIGNUP_EMAIL_SETUP.txt.
