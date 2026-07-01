This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

Copy the environment variable template and fill in your Supabase project values:

```bash
cp .env.local.example .env.local
```

Then run the development server:

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

## Stack

- Next.js 15 (App Router, TypeScript, strict mode)
- Tailwind CSS + shadcn/ui
- Supabase (`@supabase/ssr`) for auth, with browser/server clients and session-refresh middleware
- [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) with Cormorant Garamond (headings) and Jost (body)

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!
