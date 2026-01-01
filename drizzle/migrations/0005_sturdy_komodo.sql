CREATE TABLE `support_tickets` (
	`id` text PRIMARY KEY NOT NULL,
	`ticket_number` text NOT NULL,
	`user_id` text,
	`order_id` text,
	`category` text NOT NULL,
	`subject` text NOT NULL,
	`description` text NOT NULL,
	`status` text DEFAULT 'open',
	`priority` text DEFAULT 'medium',
	`customer_name` text NOT NULL,
	`customer_email` text,
	`customer_phone` text,
	`resolved_at` integer,
	`resolution` text,
	`created_at` integer,
	`updated_at` integer,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE set null,
	FOREIGN KEY (`order_id`) REFERENCES `orders`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
CREATE UNIQUE INDEX `support_tickets_ticket_number_unique` ON `support_tickets` (`ticket_number`);