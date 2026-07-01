/**
 * Placeholder Supabase database types.
 *
 * No migrations have been run yet. Once the database schema exists, replace
 * this file with generated types, e.g.:
 *
 *   npx supabase gen types typescript --project-id <project-id> > types/supabase.ts
 */
export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export type Database = {
  public: {
    Tables: Record<string, never>;
    Views: Record<string, never>;
    Functions: Record<string, never>;
    Enums: Record<string, never>;
    CompositeTypes: Record<string, never>;
  };
};
