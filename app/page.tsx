import Link from "next/link";

export default function Home() {
  return (
    <div className="flex min-h-screen flex-col items-center justify-center gap-6 bg-ivory px-6 text-center">
      <h1 className="font-serif text-4xl font-medium text-forest">
        Minose CRM
      </h1>
      <p className="max-w-md text-hunter">
        Manage your client relationships with clarity and care.
      </p>
      <Link
        href="/login"
        className="rounded-md bg-forest px-5 py-2.5 text-sm font-medium text-ivory transition-colors hover:bg-hunter"
      >
        Sign in
      </Link>
    </div>
  );
}
