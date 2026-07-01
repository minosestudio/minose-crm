import type { Metadata } from "next";

import { LoginForm } from "@/components/auth/login-form";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";

export const metadata: Metadata = {
  title: "Sign in | Minose CRM",
};

export default function LoginPage() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-ivory px-4">
      <Card className="w-full max-w-sm border-tan/30">
        <CardHeader>
          <CardTitle className="text-2xl text-forest">Minose CRM</CardTitle>
          <CardDescription>
            Sign in with your email and password to continue.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <LoginForm />
        </CardContent>
      </Card>
    </div>
  );
}
