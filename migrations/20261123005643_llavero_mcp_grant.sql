CREATE TABLE `llavero_mcp_grant` (
	`id` text PRIMARY KEY,
	`user_id` text NOT NULL,
	`client_id` text NOT NULL,
	`session_id` text,
	`scopes` text NOT NULL,
	`orgs` text NOT NULL,
	`created_at` integer NOT NULL,
	`superseded_at` integer,
	`superseded_by` text,
	`revoked_at` integer,
	CONSTRAINT `fk_llavero_mcp_grant_user_id_user_id_fk` FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_mcp_grant_client_id_oauth_client_client_id_fk` FOREIGN KEY (`client_id`) REFERENCES `oauth_client`(`client_id`) ON DELETE CASCADE,
	CONSTRAINT `fk_llavero_mcp_grant_session_id_session_id_fk` FOREIGN KEY (`session_id`) REFERENCES `session`(`id`) ON DELETE SET NULL
);
--> statement-breakpoint
CREATE INDEX `llavero_mcp_grant_user_client_idx` ON `llavero_mcp_grant` (`user_id`,`client_id`);--> statement-breakpoint
CREATE UNIQUE INDEX `llavero_mcp_grant_active_idx` ON `llavero_mcp_grant` (`user_id`,`client_id`) WHERE superseded_at IS NULL AND revoked_at IS NULL;