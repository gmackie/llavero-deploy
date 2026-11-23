CREATE TABLE `llavero_approval` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`plan_id` text NOT NULL,
	`digest` text NOT NULL,
	`approver` text NOT NULL,
	`approved_at` integer NOT NULL,
	`expires_at` integer NOT NULL,
	`invalidated_at` integer,
	CONSTRAINT `fk_llavero_approval_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_approval_plan_id_llavero_plan_id_fk` FOREIGN KEY (`plan_id`) REFERENCES `llavero_plan`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `llavero_audit_entry` (
	`org_id` text NOT NULL,
	`seq` integer NOT NULL,
	`event_id` text NOT NULL UNIQUE,
	`at` integer NOT NULL,
	`action` text NOT NULL,
	`actor` text NOT NULL,
	`subject` text NOT NULL,
	`prev_hash` text NOT NULL,
	`hash` text NOT NULL,
	CONSTRAINT `llavero_audit_entry_pk` PRIMARY KEY(`org_id`, `seq`),
	CONSTRAINT `fk_llavero_audit_entry_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `llavero_binding` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`credential_id` text NOT NULL,
	`destination_id` text NOT NULL,
	`environment_id` text,
	`field` text DEFAULT 'value' NOT NULL,
	`version_policy` text DEFAULT 'latest' NOT NULL,
	`pinned_version_id` text,
	`shared_exception` integer DEFAULT false NOT NULL,
	`shared_rationale` text,
	`shared_consumers` text,
	`shared_approver` text,
	`verify` text,
	`source` text NOT NULL,
	`disabled_at` integer,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_binding_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_binding_credential_id_llavero_credential_id_fk` FOREIGN KEY (`credential_id`) REFERENCES `llavero_credential`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_binding_destination_id_llavero_destination_id_fk` FOREIGN KEY (`destination_id`) REFERENCES `llavero_destination`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_binding_environment_id_llavero_environment_id_fk` FOREIGN KEY (`environment_id`) REFERENCES `llavero_environment`(`id`) ON DELETE SET NULL
);
--> statement-breakpoint
CREATE TABLE `llavero_credential` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`ref` text NOT NULL,
	`description` text NOT NULL,
	`fields` text NOT NULL,
	`custody` text DEFAULT 'vault' NOT NULL,
	`source` text NOT NULL,
	`issuer` text,
	`project_id` text,
	`environment_id` text,
	`connection_id` text,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_credential_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_credential_project_id_llavero_project_id_fk` FOREIGN KEY (`project_id`) REFERENCES `llavero_project`(`id`) ON DELETE SET NULL,
	CONSTRAINT `fk_llavero_credential_environment_id_llavero_environment_id_fk` FOREIGN KEY (`environment_id`) REFERENCES `llavero_environment`(`id`) ON DELETE SET NULL,
	CONSTRAINT `fk_llavero_credential_connection_id_llavero_project_connection_id_fk` FOREIGN KEY (`connection_id`) REFERENCES `llavero_project_connection`(`id`) ON DELETE SET NULL,
	CONSTRAINT `llavero_credential_org_ref_unique` UNIQUE(`org_id`,`ref`)
);
--> statement-breakpoint
CREATE TABLE `llavero_destination` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`kind` text NOT NULL,
	`target` text NOT NULL,
	`identity` text NOT NULL,
	`label` text NOT NULL,
	`source` text NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_destination_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `llavero_destination_org_identity_unique` UNIQUE(`org_id`,`identity`)
);
--> statement-breakpoint
CREATE TABLE `llavero_environment` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`project_id` text NOT NULL,
	`slug` text NOT NULL,
	`stage` text NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_environment_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_environment_project_id_llavero_project_id_fk` FOREIGN KEY (`project_id`) REFERENCES `llavero_project`(`id`) ON DELETE CASCADE,
	CONSTRAINT `llavero_environment_project_slug_unique` UNIQUE(`project_id`,`slug`)
);
--> statement-breakpoint
CREATE TABLE `llavero_export` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`credential_id` text NOT NULL,
	`version_id` text NOT NULL,
	`fields` text NOT NULL,
	`user_id` text NOT NULL,
	`requested_by` text NOT NULL,
	`status` text NOT NULL,
	`created_at` integer NOT NULL,
	`expires_at` integer NOT NULL,
	`approved_at` integer,
	`approved_by` text,
	`delivered_at` integer,
	CONSTRAINT `fk_llavero_export_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_export_credential_id_llavero_credential_id_fk` FOREIGN KEY (`credential_id`) REFERENCES `llavero_credential`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `llavero_intake_ticket` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`credential_id` text NOT NULL,
	`request_id` text,
	`fields` text NOT NULL,
	`created_by` text NOT NULL,
	`created_at` integer NOT NULL,
	`expires_at` integer NOT NULL,
	`used_at` integer,
	`version_id` text,
	CONSTRAINT `fk_llavero_intake_ticket_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_intake_ticket_credential_id_llavero_credential_id_fk` FOREIGN KEY (`credential_id`) REFERENCES `llavero_credential`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_intake_ticket_request_id_llavero_request_id_fk` FOREIGN KEY (`request_id`) REFERENCES `llavero_request`(`id`) ON DELETE SET NULL
);
--> statement-breakpoint
CREATE TABLE `llavero_membership` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`email` text NOT NULL,
	`role` text DEFAULT 'member' NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_membership_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `llavero_membership_org_email_unique` UNIQUE(`org_id`,`email`)
);
--> statement-breakpoint
CREATE TABLE `llavero_organization` (
	`id` text PRIMARY KEY,
	`slug` text NOT NULL UNIQUE,
	`name` text NOT NULL,
	`workspace_id` text,
	`registry_digest` text,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_organization_workspace_id_workspace_id_fk` FOREIGN KEY (`workspace_id`) REFERENCES `workspace`(`id`) ON DELETE SET NULL
);
--> statement-breakpoint
CREATE TABLE `llavero_plan` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`request_id` text NOT NULL,
	`kind` text NOT NULL,
	`canonical` text NOT NULL,
	`digest` text NOT NULL,
	`status` text NOT NULL,
	`proposed_by` text NOT NULL,
	`revision` integer DEFAULT 0 NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_plan_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_plan_request_id_llavero_request_id_fk` FOREIGN KEY (`request_id`) REFERENCES `llavero_request`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `llavero_plan_step` (
	`plan_id` text NOT NULL,
	`seq` integer NOT NULL,
	`binding_id` text NOT NULL,
	`credential_ref` text NOT NULL,
	`version_id` text NOT NULL,
	`destination_id` text NOT NULL,
	`key` text NOT NULL,
	`field` text NOT NULL,
	`status` text DEFAULT 'pending' NOT NULL,
	`idempotency_key` text NOT NULL UNIQUE,
	`receipt_id` text,
	`detail` text,
	`http_status` integer,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_plan_step_plan_id_llavero_plan_id_fk` FOREIGN KEY (`plan_id`) REFERENCES `llavero_plan`(`id`) ON DELETE CASCADE,
	CONSTRAINT `llavero_plan_step_plan_seq_unique` UNIQUE(`plan_id`,`seq`)
);
--> statement-breakpoint
CREATE TABLE `llavero_project` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`slug` text NOT NULL,
	`name` text NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_project_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `llavero_project_org_slug_unique` UNIQUE(`org_id`,`slug`)
);
--> statement-breakpoint
CREATE TABLE `llavero_project_connection` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`project_id` text NOT NULL,
	`provider_account_id` text NOT NULL,
	`intended_use` text NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_project_connection_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_project_connection_project_id_llavero_project_id_fk` FOREIGN KEY (`project_id`) REFERENCES `llavero_project`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_project_connection_provider_account_id_llavero_provider_account_id_fk` FOREIGN KEY (`provider_account_id`) REFERENCES `llavero_provider_account`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `llavero_provider_account` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`provider` text NOT NULL,
	`external_id` text NOT NULL,
	`label` text NOT NULL,
	`region` text,
	`mode` text DEFAULT 'live' NOT NULL,
	`authority_class` text DEFAULT 'standard' NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_provider_account_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `llavero_provider_account_identity_unique` UNIQUE(`org_id`,`provider`,`external_id`)
);
--> statement-breakpoint
CREATE TABLE `llavero_request` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`kind` text NOT NULL,
	`credential_id` text,
	`status` text NOT NULL,
	`requested_by` text NOT NULL,
	`summary` text NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_request_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_request_credential_id_llavero_credential_id_fk` FOREIGN KEY (`credential_id`) REFERENCES `llavero_credential`(`id`) ON DELETE SET NULL
);
--> statement-breakpoint
ALTER TABLE `llavero_audit_index` ADD `org_id` text;--> statement-breakpoint
ALTER TABLE `llavero_credential_version` ADD `org_id` text;--> statement-breakpoint
ALTER TABLE `llavero_credential_version` ADD `fields` text;--> statement-breakpoint
ALTER TABLE `llavero_credential_version` ADD `expires_at` integer;--> statement-breakpoint
ALTER TABLE `llavero_receipt` ADD `org_id` text;--> statement-breakpoint
ALTER TABLE `llavero_receipt` ADD `plan_id` text;--> statement-breakpoint
ALTER TABLE `llavero_receipt` ADD `step_seq` integer;--> statement-breakpoint
ALTER TABLE `llavero_receipt` ADD `detail` text;--> statement-breakpoint
ALTER TABLE `llavero_receipt` ADD `correlation_id` text;--> statement-breakpoint
ALTER TABLE `llavero_receipt` ADD `idempotency_key` text;--> statement-breakpoint
CREATE INDEX `llavero_approval_plan_idx` ON `llavero_approval` (`plan_id`);--> statement-breakpoint
CREATE INDEX `llavero_export_org_created_idx` ON `llavero_export` (`org_id`,`created_at`);--> statement-breakpoint
CREATE INDEX `llavero_plan_org_created_idx` ON `llavero_plan` (`org_id`,`created_at`);--> statement-breakpoint
CREATE INDEX `llavero_request_org_created_idx` ON `llavero_request` (`org_id`,`created_at`);