/**
 * Generated from supabase/migrations/0001_init.sql.
 *
 * Once the migration has been run against the live project, keep this file
 * in sync by regenerating it, e.g.:
 *
 *   npx supabase gen types typescript --project-id <project-id> > types/database.ts
 *
 * Note: the literal union types below (e.g. contact_type, status) are
 * hand-authored from this migration's CHECK constraints for stronger type
 * safety. A raw `supabase gen types` run will type plain `text` columns as
 * `string` instead, since it cannot infer CHECK constraint values.
 */
export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export type ContactType =
  | "client"
  | "architect"
  | "interior_designer"
  | "builder"
  | "developer"
  | "vendor"
  | "manufacturer"
  | "other";

export type LeadTemperature = "hot" | "warm" | "cold";
export type Priority = "high" | "medium" | "low";
export type ContactStatus = "active" | "inactive" | "duplicate" | "spam";
export type ProjectType = "residential" | "commercial" | "hospitality" | "office";
export type TaskType = "call" | "whatsapp" | "email" | "meeting" | "visit" | "follow_up";
export type UserRole = "admin" | "sales_manager" | "sales_executive";
export type CustomFieldEntity = "contact" | "project";
export type CustomFieldType = "text" | "number" | "date" | "select";

export type Database = {
  public: {
    Tables: {
      users_profile: {
        Row: {
          id: string;
          full_name: string | null;
          email: string | null;
          role: UserRole | null;
          is_active: boolean;
          created_at: string;
        };
        Insert: {
          id: string;
          full_name?: string | null;
          email?: string | null;
          role?: UserRole | null;
          is_active?: boolean;
          created_at?: string;
        };
        Update: {
          id?: string;
          full_name?: string | null;
          email?: string | null;
          role?: UserRole | null;
          is_active?: boolean;
          created_at?: string;
        };
      };
      lead_sources: {
        Row: {
          id: string;
          name: string;
          is_active: boolean;
          sort_order: number | null;
        };
        Insert: {
          id?: string;
          name: string;
          is_active?: boolean;
          sort_order?: number | null;
        };
        Update: {
          id?: string;
          name?: string;
          is_active?: boolean;
          sort_order?: number | null;
        };
      };
      pipeline_stages: {
        Row: {
          id: string;
          name: string;
          sort_order: number | null;
          is_won: boolean;
          is_lost: boolean;
        };
        Insert: {
          id?: string;
          name: string;
          sort_order?: number | null;
          is_won?: boolean;
          is_lost?: boolean;
        };
        Update: {
          id?: string;
          name?: string;
          sort_order?: number | null;
          is_won?: boolean;
          is_lost?: boolean;
        };
      };
      contacts: {
        Row: {
          id: string;
          name: string;
          phone: string | null;
          whatsapp: string | null;
          email: string | null;
          company: string | null;
          city: string | null;
          country: string | null;
          contact_type: ContactType;
          source_id: string | null;
          lead_temperature: LeadTemperature | null;
          priority: Priority | null;
          status: ContactStatus;
          assigned_to: string | null;
          next_followup: string | null;
          last_contacted_at: string | null;
          tags: string[] | null;
          custom_fields: Json;
          is_deleted: boolean;
          created_by: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          phone?: string | null;
          whatsapp?: string | null;
          email?: string | null;
          company?: string | null;
          city?: string | null;
          country?: string | null;
          contact_type?: ContactType;
          source_id?: string | null;
          lead_temperature?: LeadTemperature | null;
          priority?: Priority | null;
          status?: ContactStatus;
          assigned_to?: string | null;
          next_followup?: string | null;
          last_contacted_at?: string | null;
          tags?: string[] | null;
          custom_fields?: Json;
          is_deleted?: boolean;
          created_by?: string | null;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          phone?: string | null;
          whatsapp?: string | null;
          email?: string | null;
          company?: string | null;
          city?: string | null;
          country?: string | null;
          contact_type?: ContactType;
          source_id?: string | null;
          lead_temperature?: LeadTemperature | null;
          priority?: Priority | null;
          status?: ContactStatus;
          assigned_to?: string | null;
          next_followup?: string | null;
          last_contacted_at?: string | null;
          tags?: string[] | null;
          custom_fields?: Json;
          is_deleted?: boolean;
          created_by?: string | null;
          created_at?: string;
          updated_at?: string;
        };
      };
      projects: {
        Row: {
          id: string;
          name: string;
          contact_id: string;
          project_type: ProjectType | null;
          stage_id: string;
          expected_value: number | null;
          currency: string;
          expected_closing_date: string | null;
          won_date: string | null;
          lost_reason: string | null;
          architect_contact_id: string | null;
          interior_designer_contact_id: string | null;
          assigned_to: string | null;
          custom_fields: Json;
          is_deleted: boolean;
          created_at: string;
          updated_at: string;
        };
        Insert: {
          id?: string;
          name: string;
          contact_id: string;
          project_type?: ProjectType | null;
          stage_id: string;
          expected_value?: number | null;
          currency?: string;
          expected_closing_date?: string | null;
          won_date?: string | null;
          lost_reason?: string | null;
          architect_contact_id?: string | null;
          interior_designer_contact_id?: string | null;
          assigned_to?: string | null;
          custom_fields?: Json;
          is_deleted?: boolean;
          created_at?: string;
          updated_at?: string;
        };
        Update: {
          id?: string;
          name?: string;
          contact_id?: string;
          project_type?: ProjectType | null;
          stage_id?: string;
          expected_value?: number | null;
          currency?: string;
          expected_closing_date?: string | null;
          won_date?: string | null;
          lost_reason?: string | null;
          architect_contact_id?: string | null;
          interior_designer_contact_id?: string | null;
          assigned_to?: string | null;
          custom_fields?: Json;
          is_deleted?: boolean;
          created_at?: string;
          updated_at?: string;
        };
      };
      notes: {
        Row: {
          id: string;
          contact_id: string | null;
          project_id: string | null;
          note: string;
          created_by: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          contact_id?: string | null;
          project_id?: string | null;
          note: string;
          created_by?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          contact_id?: string | null;
          project_id?: string | null;
          note?: string;
          created_by?: string | null;
          created_at?: string;
        };
      };
      tasks: {
        Row: {
          id: string;
          contact_id: string | null;
          project_id: string | null;
          title: string;
          task_type: TaskType | null;
          due_date: string | null;
          priority: Priority;
          assigned_to: string | null;
          done: boolean;
          created_at: string;
        };
        Insert: {
          id?: string;
          contact_id?: string | null;
          project_id?: string | null;
          title: string;
          task_type?: TaskType | null;
          due_date?: string | null;
          priority?: Priority;
          assigned_to?: string | null;
          done?: boolean;
          created_at?: string;
        };
        Update: {
          id?: string;
          contact_id?: string | null;
          project_id?: string | null;
          title?: string;
          task_type?: TaskType | null;
          due_date?: string | null;
          priority?: Priority;
          assigned_to?: string | null;
          done?: boolean;
          created_at?: string;
        };
      };
      activity_log: {
        Row: {
          id: string;
          contact_id: string | null;
          project_id: string | null;
          actor_id: string | null;
          action_type: string | null;
          description: string | null;
          created_at: string;
        };
        Insert: {
          id?: string;
          contact_id?: string | null;
          project_id?: string | null;
          actor_id?: string | null;
          action_type?: string | null;
          description?: string | null;
          created_at?: string;
        };
        Update: {
          id?: string;
          contact_id?: string | null;
          project_id?: string | null;
          actor_id?: string | null;
          action_type?: string | null;
          description?: string | null;
          created_at?: string;
        };
      };
      custom_field_definitions: {
        Row: {
          id: string;
          entity: CustomFieldEntity;
          field_key: string;
          field_label: string;
          field_type: CustomFieldType;
          options: string[] | null;
          sort_order: number | null;
        };
        Insert: {
          id?: string;
          entity: CustomFieldEntity;
          field_key: string;
          field_label: string;
          field_type: CustomFieldType;
          options?: string[] | null;
          sort_order?: number | null;
        };
        Update: {
          id?: string;
          entity?: CustomFieldEntity;
          field_key?: string;
          field_label?: string;
          field_type?: CustomFieldType;
          options?: string[] | null;
          sort_order?: number | null;
        };
      };
    };
    Views: Record<string, never>;
    Functions: {
      current_user_role: {
        Args: Record<PropertyKey, never>;
        Returns: string | null;
      };
    };
    Enums: Record<string, never>;
    CompositeTypes: Record<string, never>;
  };
};
