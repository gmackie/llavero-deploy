CREATE TABLE `llavero_audit_index` (
	`seq` integer PRIMARY KEY,
	`event_id` text NOT NULL UNIQUE,
	`at` integer NOT NULL,
	`action` text NOT NULL,
	`actor` text NOT NULL,
	`subject` text NOT NULL,
	`prev_hash` text NOT NULL,
	`hash` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `llavero_credential_version` (
	`id` text PRIMARY KEY,
	`credential` text NOT NULL,
	`created_at` integer NOT NULL,
	`actor` text NOT NULL,
	`length` integer NOT NULL,
	`fingerprint` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `llavero_receipt` (
	`id` text PRIMARY KEY,
	`binding` text NOT NULL,
	`credential` text NOT NULL,
	`version_id` text NOT NULL,
	`destination` text NOT NULL,
	`actor` text NOT NULL,
	`status` text NOT NULL,
	`http_status` integer,
	`delivered_at` integer NOT NULL,
	`verify_run_id` integer,
	`verify_run_url` text,
	`verify_status` text,
	`verified_at` integer
);
--> statement-breakpoint
CREATE INDEX `llavero_credential_version_credential_idx` ON `llavero_credential_version` (`credential`,`created_at`);--> statement-breakpoint
CREATE INDEX `llavero_receipt_binding_idx` ON `llavero_receipt` (`binding`,`delivered_at`);