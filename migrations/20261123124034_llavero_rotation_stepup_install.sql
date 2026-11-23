CREATE TABLE `llavero_install` (
	`id` text PRIMARY KEY,
	`claimed_at` integer,
	`owner_user_id` text,
	`owner_email` text,
	`root_key_fingerprint` text,
	`rewrapped_at` integer
);
--> statement-breakpoint
CREATE TABLE `llavero_rotation_policy` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`policy` text NOT NULL,
	`digest` text NOT NULL,
	`authority_ref` text,
	`status` text NOT NULL,
	`approved_digest` text,
	`approved_by` text,
	`approved_at` integer,
	`proposed_by` text NOT NULL,
	`needs_step_up` integer DEFAULT false NOT NULL,
	`current_resource_id` text,
	`current_issued_at` integer,
	`current_expires_at` integer,
	`run_requested_by` text,
	`run_requested_at` integer,
	`active_run_id` text,
	`revision` integer DEFAULT 0 NOT NULL,
	`created_at` integer NOT NULL,
	`updated_at` integer,
	CONSTRAINT `fk_llavero_rotation_policy_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `llavero_rotation_run` (
	`id` text PRIMARY KEY,
	`org_id` text NOT NULL,
	`policy_id` text NOT NULL,
	`seq` integer NOT NULL,
	`state` text NOT NULL,
	`run` text NOT NULL,
	`wake_at` integer,
	`created_at` integer NOT NULL,
	`updated_at` integer NOT NULL,
	CONSTRAINT `fk_llavero_rotation_run_org_id_llavero_organization_id_fk` FOREIGN KEY (`org_id`) REFERENCES `llavero_organization`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_rotation_run_policy_id_llavero_rotation_policy_id_fk` FOREIGN KEY (`policy_id`) REFERENCES `llavero_rotation_policy`(`id`) ON DELETE CASCADE
);
--> statement-breakpoint
CREATE TABLE `llavero_stepup_device` (
	`id` text PRIMARY KEY,
	`owner_id` text NOT NULL,
	`record` text NOT NULL,
	`enrolled_at` integer NOT NULL,
	`revoked_at` integer
);
--> statement-breakpoint
CREATE TABLE `llavero_stepup_pairing` (
	`code_hash` text PRIMARY KEY,
	`owner_id` text NOT NULL,
	`expires_at` integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE `llavero_stepup_reprompt` (
	`grant_id` text NOT NULL,
	`digest` text NOT NULL,
	`created_at` integer NOT NULL,
	CONSTRAINT `llavero_stepup_reprompt_pk` PRIMARY KEY(`grant_id`, `digest`)
);
--> statement-breakpoint
CREATE TABLE `llavero_stepup_request` (
	`id` text PRIMARY KEY,
	`owner_id` text NOT NULL,
	`grant_id` text NOT NULL,
	`digest` text NOT NULL,
	`state` text NOT NULL,
	`version` integer NOT NULL,
	`record` text NOT NULL,
	`created_at` integer NOT NULL,
	`expires_at` integer NOT NULL
);
--> statement-breakpoint
ALTER TABLE `llavero_approval` ADD `step_up_request_id` text;--> statement-breakpoint
ALTER TABLE `llavero_plan` ADD `needs_step_up` integer DEFAULT false NOT NULL;--> statement-breakpoint
CREATE INDEX `llavero_rotation_policy_org_idx` ON `llavero_rotation_policy` (`org_id`);--> statement-breakpoint
CREATE INDEX `llavero_rotation_run_policy_idx` ON `llavero_rotation_run` (`policy_id`);--> statement-breakpoint
CREATE INDEX `llavero_rotation_run_state_idx` ON `llavero_rotation_run` (`state`);--> statement-breakpoint
CREATE INDEX `llavero_stepup_device_owner_idx` ON `llavero_stepup_device` (`owner_id`);--> statement-breakpoint
CREATE INDEX `llavero_stepup_request_owner_idx` ON `llavero_stepup_request` (`owner_id`);--> statement-breakpoint
CREATE INDEX `llavero_stepup_request_grant_idx` ON `llavero_stepup_request` (`grant_id`,`created_at`);--> statement-breakpoint
CREATE INDEX `llavero_stepup_request_state_idx` ON `llavero_stepup_request` (`state`);