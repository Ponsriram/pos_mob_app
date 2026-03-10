# POS App ↔ Backend — Data Field Mapping & Analysis

## Status Legend

| Icon | Meaning                                                                          |
| ---- | -------------------------------------------------------------------------------- |
| ✅   | **REQUIRED** — Actively used by the app, must be fetched from backend            |
| ❌   | **NOT REQUIRED** — Backend has it, but app never uses it (safe to skip fetching) |
| ⚠️   | **FUTURE USE** — Repository/model exists in app but UI is incomplete or unused   |
| 🔄   | **SEND ONLY** — App sends this to backend but doesn't display it                 |

---

## Table of Contents

1. [Users & Authentication](#1-users--authentication)
2. [Stores & Infrastructure](#2-stores--infrastructure)
3. [Products & Categories](#3-products--categories)
4. [Menus & Scheduling](#4-menus--scheduling)
5. [Orders & Order Items](#5-orders--order-items)
6. [Payments](#6-payments)
7. [Billing - KOTs, Invoices, Templates](#7-billing---kots-invoices-templates)
8. [Shifts & Day Close](#8-shifts--day-close)
9. [Inventory](#9-inventory)
10. [Purchasing & Vendors](#10-purchasing--vendors)
11. [Guests & CRM](#11-guests--crm)
12. [Delivery](#12-delivery)
13. [Tax & Ledger](#13-tax--ledger)
14. [Zones](#14-zones)
15. [Permission Groups](#15-permission-groups)
16. [Integrations & Aggregators](#16-integrations--aggregators)
17. [Marketing & Campaigns](#17-marketing--campaigns)
18. [Notifications](#18-notifications)
19. [Audit Logs](#19-audit-logs)
20. [Reports & Analytics](#20-reports--analytics)
21. [Summary & Recommendations](#21-summary--recommendations)

---

## 1. Users & Authentication

**Backend Table**: `users`  
**App Model**: `AppUser`, `SubUserModel`, `ProfileModel`  
**App Usage**: ✅ **ACTIVE** — Auth, profile, cloud access, sub-user management

| Backend Field   | Type        | App Field           | Status | Notes                                     |
| --------------- | ----------- | ------------------- | ------ | ----------------------------------------- |
| `id`            | UUID        | `id`                | ✅     | Primary identifier everywhere             |
| `name`          | String(120) | `name` / `fullName` | ✅     | Display name                              |
| `email`         | String(255) | `email`             | ✅     | Login + display                           |
| `phone`         | String(20)  | `phone`             | ✅     | Profile display                           |
| `password_hash` | String(255) | —                   | 🔄     | Sent during register/login, never fetched |
| `role`          | String(50)  | `role`              | ✅     | Role-based UI rendering                   |
| `is_active`     | Boolean     | `isActive`          | ✅     | Active status                             |
| `created_by_id` | UUID        | `createdBy`         | ✅     | User hierarchy (owner → sub-users)        |
| `created_at`    | DateTime    | `createdAt`         | ✅     | Profile display                           |

**Backend Table**: `user_permissions`  
**App Usage**: ✅ **ACTIVE** — Permission checks in UI

| Backend Field | Type        | App Field    | Status | Notes                    |
| ------------- | ----------- | ------------ | ------ | ------------------------ |
| `id`          | UUID        | `id`         | ✅     |                          |
| `user_id`     | UUID        | `userId`     | ✅     |                          |
| `permission`  | String(100) | `permission` | ✅     | Controls UI visibility   |
| `store_id`    | UUID        | `storeId`    | ✅     | Store-scoped permissions |

---

## 2. Stores & Infrastructure

**Backend Table**: `stores`  
**App Model**: `StoreModel`  
**App Usage**: ✅ **CRITICAL** — Used in 14+ features, most heavily used model

| Backend Field   | Type        | App Field      | Status | Notes                       |
| --------------- | ----------- | -------------- | ------ | --------------------------- |
| `id`            | UUID        | `id`           | ✅     | Used everywhere             |
| `owner_id`      | UUID        | `ownerId`      | ✅     | Store ownership             |
| `name`          | String(200) | `name`         | ✅     | Display throughout app      |
| `location`      | Text        | `location`     | ✅     | Outlet details              |
| `phone`         | String(20)  | `phone`        | ✅     | Store contact display       |
| `email`         | String(255) | `email`        | ✅     | Store contact display       |
| `timezone`      | String(64)  | `timezone`     | ✅     | Business date calculations  |
| `currency`      | String(3)   | `currency`     | ✅     | Price formatting            |
| `tax_inclusive` | Boolean     | `taxInclusive` | ✅     | Tax calculation mode        |
| `chain_id`      | UUID        | `chainId`      | ✅     | Franchise linking           |
| `state`         | String(100) | `state`        | ✅     | Outlet details              |
| `city`          | String(100) | `city`         | ✅     | Outlet details              |
| `outlet_type`   | String(20)  | `outletType`   | ✅     | COFO/FOFO/COCO/FOCO display |
| `is_active`     | Boolean     | `isActive`     | ✅     | Status display              |
| `created_at`    | DateTime    | `createdAt`    | ✅     |                             |

**Backend Table**: `chains`  
**App Model**: `ChainModel`  
**App Usage**: ✅ **ACTIVE** — Franchise management

| Backend Field | Type        | App Field   | Status | Notes              |
| ------------- | ----------- | ----------- | ------ | ------------------ |
| `id`          | UUID        | `id`        | ✅     |                    |
| `owner_id`    | UUID        | `ownerId`   | ✅     |                    |
| `name`        | String(200) | `name`      | ✅     | Brand name display |
| `logo_url`    | String(500) | `logoUrl`   | ✅     | Brand logo         |
| `created_at`  | DateTime    | `createdAt` | ✅     |                    |

**Backend Table**: `pos_terminals`  
**App Usage**: ✅ Referenced in orders/shifts but no standalone terminal management UI

| Backend Field       | Type        | App Field                    | Status | Notes                         |
| ------------------- | ----------- | ---------------------------- | ------ | ----------------------------- |
| `id`                | UUID        | `terminalId` (in OrderModel) | ✅     | Referenced in orders          |
| `store_id`          | UUID        | —                            | ✅     | Scoped to store               |
| `device_name`       | String(120) | —                            | ❌     | No terminal management screen |
| `device_identifier` | String(255) | —                            | ❌     | No terminal management screen |
| `is_active`         | Boolean     | —                            | ❌     | No terminal management screen |
| `created_at`        | DateTime    | —                            | ❌     | No terminal management screen |

**Backend Table**: `employees`  
**App Model**: `EmployeeModel`  
**App Usage**: ✅ **ACTIVE** — Employee management

| Backend Field   | Type        | App Field      | Status | Notes                      |
| --------------- | ----------- | -------------- | ------ | -------------------------- |
| `id`            | UUID        | `id`           | ✅     |                            |
| `store_id`      | UUID        | `storeId`      | ✅     |                            |
| `user_id`       | UUID        | `userId`       | ✅     | Link to user account       |
| `name`          | String(120) | `name`         | ✅     |                            |
| `employee_code` | String(20)  | `employeeCode` | ✅     |                            |
| `pin`           | String(255) | —              | 🔄     | Sent only, never displayed |
| `phone`         | String(20)  | `phone`        | ✅     |                            |
| `email`         | String(255) | `email`        | ✅     |                            |
| `role`          | String(50)  | `role`         | ✅     |                            |
| `is_active`     | Boolean     | `isActive`     | ✅     |                            |
| `permissions`   | JSONB       | `permissions`  | ✅     |                            |
| `created_at`    | DateTime    | `createdAt`    | ✅     |                            |

**Backend Table**: `dine_in_tables`  
**App Usage**: ✅ Referenced in orders but **no standalone table management UI**

| Backend Field      | Type       | App Field                 | Status | Notes                |
| ------------------ | ---------- | ------------------------- | ------ | -------------------- |
| `id`               | UUID       | `tableId` (in OrderModel) | ✅     | Referenced in orders |
| `table_number`     | Integer    | —                         | ❌     | No table map screen  |
| `label`            | String(50) | —                         | ❌     | No table map screen  |
| `capacity`         | Integer    | —                         | ❌     | No table map screen  |
| `status`           | String(20) | —                         | ❌     | No table map screen  |
| `section`          | String(50) | —                         | ❌     | No table map screen  |
| `zone`             | String(50) | —                         | ❌     | No table map screen  |
| `position_x`       | Integer    | —                         | ❌     | No floor map UI      |
| `position_y`       | Integer    | —                         | ❌     | No floor map UI      |
| `is_active`        | Boolean    | —                         | ❌     | No table management  |
| `current_order_id` | UUID       | —                         | ❌     | Not used             |

**Backend Table**: `expenses`  
**App Usage**: ❌ **NOT USED** — No expense tracking UI exists in app

| Backend Field | Type        | App Field | Status | Notes         |
| ------------- | ----------- | --------- | ------ | ------------- |
| `id`          | UUID        | —         | ❌     | No expense UI |
| `store_id`    | UUID        | —         | ❌     |               |
| `title`       | String(200) | —         | ❌     |               |
| `amount`      | Numeric     | —         | ❌     |               |
| `category`    | String(100) | —         | ❌     |               |
| `notes`       | Text        | —         | ❌     |               |
| `shift_id`    | UUID        | —         | ❌     |               |
| `created_at`  | DateTime    | —         | ❌     |               |

---

## 3. Products & Categories

**Backend Table**: `categories`  
**App Model**: `CategoryModel`  
**App Usage**: ⚠️ **FUTURE** — Model exists, repository defined, but **0 usages** in any UI screen

| Backend Field | Type        | App Field   | Status | Notes                       |
| ------------- | ----------- | ----------- | ------ | --------------------------- |
| `id`          | UUID        | `id`        | ⚠️     | Model defined, not rendered |
| `store_id`    | UUID        | `storeId`   | ⚠️     |                             |
| `name`        | String(120) | `name`      | ⚠️     |                             |
| `created_at`  | DateTime    | `createdAt` | ⚠️     |                             |

**Backend Table**: `products`  
**App Model**: `ProductModel`  
**App Usage**: ⚠️ **FUTURE** — ProductRepository has **0 usages** in any feature screen

| Backend Field | Type        | App Field     | Status | Notes                       |
| ------------- | ----------- | ------------- | ------ | --------------------------- |
| `id`          | UUID        | `id`          | ⚠️     | Model defined, not rendered |
| `store_id`    | UUID        | `storeId`     | ⚠️     |                             |
| `category_id` | UUID        | `categoryId`  | ⚠️     |                             |
| `name`        | String(200) | `name`        | ⚠️     |                             |
| `description` | Text        | `description` | ⚠️     |                             |
| `price`       | Numeric     | `price`       | ⚠️     |                             |
| `tax_percent` | Numeric     | `taxPercent`  | ⚠️     |                             |
| `is_active`   | Boolean     | `isActive`    | ⚠️     |                             |
| `created_at`  | DateTime    | `createdAt`   | ⚠️     |                             |
| `updated_at`  | DateTime    | `updatedAt`   | ⚠️     |                             |

---

## 4. Menus & Scheduling

**Backend Table**: `menus`, `menu_items`, `menu_schedules`, `menu_pricing_rules`  
**App Model**: `MenuModel`, `MenuItemModel`, `MenuScheduleModel`  
**App Usage**: ⚠️ **FUTURE** — MenuRepository has **0 usages** in any feature screen

| Backend Field          | Type        | App Field             | Status | Notes                                 |
| ---------------------- | ----------- | --------------------- | ------ | ------------------------------------- |
| **menus**              |             |                       |        |                                       |
| `id`                   | UUID        | `id`                  | ⚠️     |                                       |
| `store_id`             | UUID        | `storeId`             | ⚠️     |                                       |
| `name`                 | String(120) | `name`                | ⚠️     |                                       |
| `description`          | Text        | `description`         | ⚠️     |                                       |
| `menu_type`            | String(30)  | `menuType`            | ⚠️     |                                       |
| `is_active`            | Boolean     | `isActive`            | ⚠️     |                                       |
| `valid_from`           | Date        | `validFrom`           | ⚠️     |                                       |
| `valid_until`          | Date        | `validUntil`          | ⚠️     |                                       |
| `channels`             | JSONB       | `channels`            | ⚠️     |                                       |
| `sort_order`           | Integer     | `sortOrder`           | ⚠️     |                                       |
| `created_at`           | DateTime    | `createdAt`           | ⚠️     |                                       |
| **menu_items**         |             |                       |        |                                       |
| `id`                   | UUID        | `id`                  | ⚠️     |                                       |
| `menu_id`              | UUID        | `menuId`              | ⚠️     |                                       |
| `product_id`           | UUID        | `productId`           | ⚠️     |                                       |
| `display_name`         | String(200) | `displayName`         | ⚠️     |                                       |
| `description_override` | Text        | `descriptionOverride` | ⚠️     |                                       |
| `price_override`       | Numeric     | `priceOverride`       | ⚠️     |                                       |
| `tax_percent_override` | Numeric     | `taxPercentOverride`  | ⚠️     |                                       |
| `sort_order`           | Integer     | `sortOrder`           | ⚠️     |                                       |
| `is_visible`           | Boolean     | `isVisible`           | ⚠️     |                                       |
| `is_available`         | Boolean     | `isAvailable`         | ⚠️     |                                       |
| `tags`                 | JSONB       | `tags`                | ⚠️     |                                       |
| **menu_schedules**     |             |                       |        |                                       |
| `id`                   | UUID        | `id`                  | ⚠️     |                                       |
| `menu_id`              | UUID        | `menuId`              | ⚠️     |                                       |
| `day_of_week`          | Integer     | `dayOfWeek`           | ⚠️     |                                       |
| `start_time`           | Time        | `startTime`           | ⚠️     |                                       |
| `end_time`             | Time        | `endTime`             | ⚠️     |                                       |
| **menu_pricing_rules** |             |                       |        |                                       |
| All 15 fields          | —           | —                     | ❌     | No app model exists for pricing rules |

---

## 5. Orders & Order Items

**Backend Table**: `orders`  
**App Model**: `OrderModel`  
**App Usage**: ✅ **CRITICAL** — Running Orders, Online Orders screens

| Backend Field       | Type        | App Field        | Status | Notes                          |
| ------------------- | ----------- | ---------------- | ------ | ------------------------------ |
| `id`                | UUID        | `id`             | ✅     |                                |
| `store_id`          | UUID        | `storeId`        | ✅     |                                |
| `employee_id`       | UUID        | `employeeId`     | ✅     |                                |
| `terminal_id`       | UUID        | `terminalId`     | ✅     |                                |
| `table_id`          | UUID        | `tableId`        | ✅     |                                |
| `guest_id`          | UUID        | `guestId`        | ✅     |                                |
| `shift_id`          | UUID        | `shiftId`        | ✅     |                                |
| `order_number`      | String(30)  | `orderNumber`    | ✅     | Prominent display              |
| `order_type`        | String(20)  | `orderType`      | ✅     | Dine-in/Takeaway/Delivery tabs |
| `status`            | String(20)  | `status`         | ✅     | Order state management         |
| `channel`           | String(20)  | `channel`        | ✅     | POS/Online/Aggregator          |
| `gross_amount`      | Numeric     | `grossAmount`    | ✅     | Financial display              |
| `tax_amount`        | Numeric     | `taxAmount`      | ✅     | Financial display              |
| `discount_amount`   | Numeric     | `discountAmount` | ✅     | Financial display              |
| `service_charge`    | Numeric     | `serviceCharge`  | ✅     | Financial display              |
| `tip_amount`        | Numeric     | `tipAmount`      | ✅     | Financial display              |
| `net_amount`        | Numeric     | `netAmount`      | ✅     | Final amount                   |
| `payment_status`    | String(20)  | `paymentStatus`  | ✅     | Payment tracking               |
| `notes`             | Text        | `notes`          | ✅     | Order notes                    |
| `cancel_reason`     | String(255) | `cancelReason`   | ✅     | Cancellation info              |
| `cancelled_by`      | UUID        | —                | ❌     | Not displayed in app           |
| `cancelled_at`      | DateTime    | —                | ❌     | Not displayed in app           |
| `ledger_account_id` | UUID        | —                | ❌     | City ledger not used yet       |
| `device_id`         | String(255) | —                | 🔄     | Offline sync, sent only        |
| `sync_status`       | String(20)  | —                | 🔄     | Sync tracking                  |
| `created_at`        | DateTime    | `createdAt`      | ✅     |                                |
| `updated_at`        | DateTime    | `updatedAt`      | ✅     |                                |

**Backend Table**: `order_items`  
**App Model**: `OrderItemModel`

| Backend Field     | Type        | App Field        | Status | Notes                          |
| ----------------- | ----------- | ---------------- | ------ | ------------------------------ |
| `id`              | UUID        | `id`             | ✅     |                                |
| `order_id`        | UUID        | `orderId`        | ✅     |                                |
| `product_id`      | UUID        | `productId`      | ✅     |                                |
| `quantity`        | Integer     | `quantity`       | ✅     |                                |
| `price`           | Numeric     | `price`          | ✅     |                                |
| `tax_amount`      | Numeric     | `taxAmount`      | ✅     |                                |
| `discount_amount` | Numeric     | `discountAmount` | ✅     |                                |
| `total`           | Numeric     | `total`          | ✅     |                                |
| `status`          | String(20)  | `status`         | ✅     |                                |
| `notes`           | Text        | `notes`          | ✅     |                                |
| `cancel_reason`   | String(255) | —                | ❌     | Not shown at item level in app |
| `kot_id`          | UUID        | —                | ❌     | KOT link not used in app       |
| `kitchen_status`  | String(20)  | `kitchenStatus`  | ✅     | Kitchen display                |

**Backend Table**: `order_table_links`  
**App Usage**: ❌ — No table merge UI in app

| Backend Field | Type | App Field | Status | Notes                  |
| ------------- | ---- | --------- | ------ | ---------------------- |
| `id`          | UUID | —         | ❌     | No table merge feature |
| `order_id`    | UUID | —         | ❌     |                        |
| `table_id`    | UUID | —         | ❌     |                        |

---

## 6. Payments

**Backend Table**: `payments`  
**App Usage**: ✅ **ACTIVE** — Referenced through orders, sync endpoints

| Backend Field         | Type        | App Field | Status | Notes                   |
| --------------------- | ----------- | --------- | ------ | ----------------------- |
| `id`                  | UUID        | —         | ✅     | Via order payments      |
| `order_id`            | UUID        | —         | ✅     |                         |
| `payment_method`      | String(30)  | —         | ✅     | Cash/Card/UPI breakdown |
| `amount`              | Numeric     | —         | ✅     |                         |
| `tip_amount`          | Numeric     | —         | ✅     |                         |
| `reference`           | String(255) | —         | ✅     | Transaction refs        |
| `is_refund`           | Boolean     | —         | ✅     | Refund tracking         |
| `original_payment_id` | UUID        | —         | ❌     | Not shown in app        |
| `paid_at`             | DateTime    | —         | ✅     |                         |
| `device_id`           | String(255) | —         | 🔄     | Offline sync            |
| `sync_status`         | String(20)  | —         | 🔄     | Sync tracking           |

---

## 7. Billing - KOTs, Invoices, Templates

**Backend Tables**: `kots`, `kot_items`, `invoices`, `bill_templates`  
**App Models**: `KOTModel`, `KOTItemModel`, `InvoiceModel`, `BillTemplateModel`  
**App Usage**: ⚠️ **FUTURE** — BillingRepository has **0 usages** in any screen

| Backend Field      | Type       | App Field        | Status | Notes                       |
| ------------------ | ---------- | ---------------- | ------ | --------------------------- |
| **kots**           |            |                  |        |                             |
| `id`               | UUID       | `id`             | ⚠️     | Model defined, UI not wired |
| `order_id`         | UUID       | `orderId`        | ⚠️     |                             |
| `store_id`         | UUID       | `storeId`        | ⚠️     |                             |
| `kot_number`       | String(30) | `kotNumber`      | ⚠️     |                             |
| `kitchen_section`  | String(50) | `kitchenSection` | ⚠️     |                             |
| `status`           | String(20) | `status`         | ⚠️     |                             |
| `reprint_count`    | Integer    | `reprintCount`   | ⚠️     |                             |
| `created_at`       | DateTime   | `createdAt`      | ⚠️     |                             |
| **invoices**       |            |                  |        |                             |
| `id`               | UUID       | `id`             | ⚠️     |                             |
| `order_id`         | UUID       | `orderId`        | ⚠️     |                             |
| `invoice_number`   | String(50) | `invoiceNumber`  | ⚠️     |                             |
| `gross_amount`     | Numeric    | `grossAmount`    | ⚠️     |                             |
| `tax_amount`       | Numeric    | `taxAmount`      | ⚠️     |                             |
| `discount_amount`  | Numeric    | `discountAmount` | ⚠️     |                             |
| `service_charge`   | Numeric    | `serviceCharge`  | ⚠️     |                             |
| `net_amount`       | Numeric    | `netAmount`      | ⚠️     |                             |
| `tax_breakdown`    | JSONB      | `taxBreakdown`   | ⚠️     |                             |
| `issued_at`        | DateTime   | `issuedAt`       | ⚠️     |                             |
| **bill_templates** |            |                  |        |                             |
| All 12 fields      | —          | —                | ⚠️     | Model exists, not used      |

---

## 8. Shifts & Day Close

**Backend Tables**: `shifts`, `shift_payment_summaries`, `day_closes`  
**App Models**: `ShiftModel`, `ShiftPaymentSummaryModel`, `DayCloseModel`  
**App Usage**: ⚠️ **FUTURE** — ShiftRepository has **0 usages** in any screen  
**Note**: DayClose data may feed into dashboard/analytics indirectly

| Backend Field               | Type       | App Field        | Status | Notes                               |
| --------------------------- | ---------- | ---------------- | ------ | ----------------------------------- |
| **shifts**                  |            |                  |        |                                     |
| `id`                        | UUID       | `id`             | ⚠️     |                                     |
| `store_id`                  | UUID       | `storeId`        | ⚠️     |                                     |
| `terminal_id`               | UUID       | `terminalId`     | ⚠️     |                                     |
| `employee_id`               | UUID       | `employeeId`     | ⚠️     |                                     |
| `status`                    | String(20) | `status`         | ⚠️     |                                     |
| `opening_cash`              | Numeric    | `openingCash`    | ⚠️     |                                     |
| `closing_cash`              | Numeric    | `closingCash`    | ⚠️     |                                     |
| `expected_cash`             | Numeric    | `expectedCash`   | ⚠️     |                                     |
| `cash_variance`             | Numeric    | `cashVariance`   | ⚠️     |                                     |
| `total_sales`               | Numeric    | `totalSales`     | ⚠️     |                                     |
| `total_orders`              | Integer    | `totalOrders`    | ⚠️     |                                     |
| `notes`                     | Text       | `notes`          | ⚠️     |                                     |
| `started_at`                | DateTime   | `startedAt`      | ⚠️     |                                     |
| `ended_at`                  | DateTime   | `endedAt`        | ⚠️     |                                     |
| **shift_payment_summaries** |            |                  |        |                                     |
| `id`                        | UUID       | `id`             | ⚠️     |                                     |
| `shift_id`                  | UUID       | `shiftId`        | ⚠️     |                                     |
| `payment_method`            | String(30) | `paymentMethod`  | ⚠️     |                                     |
| `expected_amount`           | Numeric    | `expectedAmount` | ⚠️     |                                     |
| `actual_amount`             | Numeric    | `actualAmount`   | ⚠️     |                                     |
| `variance`                  | Numeric    | `variance`       | ⚠️     |                                     |
| **day_closes**              |            |                  |        |                                     |
| All 17 fields               | —          | All mapped       | ⚠️     | Model complete but ShiftRepo unused |

---

## 9. Inventory

**Backend Tables**: `inventory_items`, `inventory_units`, `inventory_locations`, `stock_levels`, `stock_adjustments`, `recipes`, `recipe_lines`, `stock_transfers`, `stock_transfer_lines`  
**App Models**: All models defined  
**App Usage**: ⚠️ **FUTURE** — InventoryRepository has **0 usages** in any screen

| Backend Table          | Field Count | App Model                | Status | Notes                            |
| ---------------------- | ----------- | ------------------------ | ------ | -------------------------------- |
| `inventory_items`      | 15 fields   | `InventoryItemModel`     | ⚠️     | All fields mapped, none rendered |
| `inventory_units`      | 6 fields    | `InventoryUnitModel`     | ⚠️     |                                  |
| `inventory_locations`  | 5 fields    | `InventoryLocationModel` | ⚠️     |                                  |
| `stock_levels`         | 5 fields    | `StockLevelModel`        | ⚠️     |                                  |
| `stock_adjustments`    | 9 fields    | `StockAdjustmentModel`   | ⚠️     |                                  |
| `recipes`              | 10 fields   | `RecipeModel`            | ⚠️     |                                  |
| `recipe_lines`         | 5 fields    | `RecipeLineModel`        | ⚠️     |                                  |
| `stock_transfers`      | 10 fields   | `StockTransferModel`     | ⚠️     |                                  |
| `stock_transfer_lines` | 6 fields    | —                        | ❌     | No app model                     |

---

## 10. Purchasing & Vendors

**Backend Tables**: `vendors`, `purchase_orders`, `purchase_order_lines`, `purchase_receipts`, `purchase_receipt_lines`  
**App Models**: `VendorModel`, `PendingPurchaseSummaryModel`  
**App Usage**: ⚠️ **PARTIAL** — PurchasingRepository is wired, ViewModel fetches data, but **UI renders empty TODO placeholder**

| Backend Table            | Field Count | App Model                     | Status | Notes                                   |
| ------------------------ | ----------- | ----------------------------- | ------ | --------------------------------------- |
| `vendors`                | 11 fields   | `VendorModel`                 | ⚠️     | Model complete, UI returns TODO         |
| `purchase_orders`        | 13 fields   | —                             | ❌     | No app model for full PO                |
| `purchase_order_lines`   | 8 fields    | —                             | ❌     | No app model                            |
| `purchase_receipts`      | 7 fields    | —                             | ❌     | No app model                            |
| `purchase_receipt_lines` | 6 fields    | —                             | ❌     | No app model                            |
| **Custom endpoint**      | —           | `PendingPurchaseSummaryModel` | ⚠️     | Summary endpoint called, display broken |

---

## 11. Guests & CRM

**Backend Table**: `guests`  
**App Model**: `GuestModel`  
**App Usage**: ⚠️ **FUTURE** — GuestRepository has **0 usages** in any screen

| Backend Field        | Type        | App Field           | Status | Notes |
| -------------------- | ----------- | ------------------- | ------ | ----- |
| `id`                 | UUID        | `id`                | ⚠️     |       |
| `store_id`           | UUID        | `storeId`           | ⚠️     |       |
| `name`               | String(120) | `name`              | ⚠️     |       |
| `phone`              | String(20)  | `phone`             | ⚠️     |       |
| `email`              | String(255) | `email`             | ⚠️     |       |
| `address`            | Text        | `address`           | ⚠️     |       |
| `dietary_preference` | String(30)  | `dietaryPreference` | ⚠️     |       |
| `spice_level`        | String(20)  | `spiceLevel`        | ⚠️     |       |
| `allergies`          | Text        | `allergies`         | ⚠️     |       |
| `notes`              | Text        | `notes`             | ⚠️     |       |
| `tags`               | JSONB       | `tags`              | ⚠️     |       |
| `total_visits`       | Integer     | `totalVisits`       | ⚠️     |       |
| `total_spend`        | Numeric     | `totalSpend`        | ⚠️     |       |
| `last_visit_at`      | DateTime    | `lastVisitAt`       | ⚠️     |       |
| `loyalty_points`     | Integer     | `loyaltyPoints`     | ⚠️     |       |
| `is_active`          | Boolean     | `isActive`          | ⚠️     |       |
| `created_at`         | DateTime    | `createdAt`         | ⚠️     |       |

---

## 12. Delivery

**Backend Table**: `delivery_order_details`  
**App Model**: `DeliveryModel`  
**App Usage**: ⚠️ **FUTURE** — DeliveryRepository has **0 usages** in any screen

| Backend Field             | Type        | App Field               | Status | Notes |
| ------------------------- | ----------- | ----------------------- | ------ | ----- |
| `id`                      | UUID        | `id`                    | ⚠️     |       |
| `order_id`                | UUID        | `orderId`               | ⚠️     |       |
| `customer_name`           | String(120) | `customerName`          | ⚠️     |       |
| `customer_phone`          | String(20)  | `customerPhone`         | ⚠️     |       |
| `delivery_address`        | Text        | `deliveryAddress`       | ⚠️     |       |
| `landmark`                | String(200) | `landmark`              | ⚠️     |       |
| `latitude`                | Numeric     | `latitude`              | ⚠️     |       |
| `longitude`               | Numeric     | `longitude`             | ⚠️     |       |
| `delivery_type`           | String(20)  | `deliveryType`          | ⚠️     |       |
| `delivery_status`         | String(30)  | `deliveryStatus`        | ⚠️     |       |
| `delivery_employee_id`    | UUID        | `deliveryEmployeeId`    | ⚠️     |       |
| `delivery_charge`         | Numeric     | `deliveryCharge`        | ⚠️     |       |
| `estimated_delivery_time` | DateTime    | `estimatedDeliveryTime` | ⚠️     |       |
| `actual_delivery_time`    | DateTime    | `actualDeliveryTime`    | ⚠️     |       |
| `proof_image_url`         | String(500) | `proofImageUrl`         | ⚠️     |       |
| `signature_url`           | String(500) | `signatureUrl`          | ⚠️     |       |
| `delivery_notes`          | Text        | `deliveryNotes`         | ⚠️     |       |
| `created_at`              | DateTime    | `createdAt`             | ⚠️     |       |
| `updated_at`              | DateTime    | `updatedAt`             | ⚠️     |       |

---

## 13. Tax & Ledger

**Backend Tables**: `tax_groups`, `tax_rules`, `city_ledger_accounts`, `city_ledger_transactions`  
**App Models**: `TaxGroupModel`, `TaxRuleModel`, `CityLedgerAccountModel`, `CityLedgerTransactionModel`  
**App Usage**: ⚠️ **FUTURE** — LedgerRepository has **0 usages** in any screen

| Backend Table              | Field Count | App Model                    | Status | Notes                         |
| -------------------------- | ----------- | ---------------------------- | ------ | ----------------------------- |
| `tax_groups`               | 6 fields    | `TaxGroupModel`              | ⚠️     | Model complete, not displayed |
| `tax_rules`                | 4 fields    | `TaxRuleModel`               | ⚠️     | Nested in TaxGroupModel       |
| `city_ledger_accounts`     | 12 fields   | `CityLedgerAccountModel`     | ⚠️     | Model complete, not displayed |
| `city_ledger_transactions` | 9 fields    | `CityLedgerTransactionModel` | ⚠️     | Model complete, not displayed |

---

## 14. Zones

**Backend Tables**: `zones`, `zone_store_links`  
**App Model**: `ZoneModel`  
**App Usage**: ✅ **ACTIVE** — Zone management screen

| Backend Field        | Type        | App Field              | Status | Notes                    |
| -------------------- | ----------- | ---------------------- | ------ | ------------------------ |
| `id`                 | UUID        | `id`                   | ✅     |                          |
| `owner_id`           | UUID        | `ownerId`              | ✅     |                          |
| `name`               | String(200) | `name`                 | ✅     |                          |
| `state`              | String(100) | `state`                | ✅     |                          |
| `city`               | String(100) | `city`                 | ✅     |                          |
| `sub_order_type`     | String(50)  | `subOrderType`         | ✅     |                          |
| `delivery_fee`       | Numeric     | `deliveryFee`          | ✅     |                          |
| `min_order_amount`   | Numeric     | `minOrderAmount`       | ✅     |                          |
| `boundary`           | JSONB       | `boundary`             | ✅     | GeoJSON                  |
| `is_active`          | Boolean     | `isActive`             | ✅     |                          |
| `created_at`         | DateTime    | `createdAt`            | ✅     |                          |
| **zone_store_links** | —           | `storeIds` (flattened) | ✅     | Flattened into ZoneModel |

---

## 15. Permission Groups

**Backend Tables**: `permission_groups`, `permission_group_members`, `permission_group_stores`  
**App Model**: `PermissionGroupModel`  
**App Usage**: ⚠️ **PARTIAL** — GroupRepository fetches data, but admin/biller group pages **render empty `SizedBox.shrink()`**

| Backend Field | Type        | App Field                   | Status | Notes                     |
| ------------- | ----------- | --------------------------- | ------ | ------------------------- |
| `id`          | UUID        | `id`                        | ⚠️     | Fetched but not displayed |
| `owner_id`    | UUID        | `ownerId`                   | ⚠️     |                           |
| `name`        | String(200) | `name`                      | ⚠️     |                           |
| `group_type`  | String(50)  | `groupType`                 | ⚠️     | admin/biller              |
| `permissions` | JSONB       | `permissions`               | ⚠️     |                           |
| `is_active`   | Boolean     | `isActive`                  | ⚠️     |                           |
| `created_at`  | DateTime    | `createdAt`                 | ⚠️     |                           |
| **members**   | —           | `memberUserIds` (flattened) | ⚠️     |                           |
| **stores**    | —           | `storeIds` (flattened)      | ⚠️     |                           |

---

## 16. Integrations & Aggregators

**Backend Tables**: `aggregator_configs`, `aggregator_store_links`, `aggregator_orders`, `integration_logs`  
**App Models**: `AggregatorConfigModel`, `AggregatorStoreLinkModel`, `AggregatorStoreStatusModel`, `IntegrationLogModel`  
**App Usage**: ✅ **ACTIVE** — Store status tracking, aggregator config, but **log pages render empty**

| Backend Field              | Type        | App Field             | Status | Notes                                      |
| -------------------------- | ----------- | --------------------- | ------ | ------------------------------------------ |
| **aggregator_configs**     |             |                       |        |                                            |
| `id`                       | UUID        | `id`                  | ✅     |                                            |
| `code`                     | String(30)  | `code`                | ✅     | Platform identifier                        |
| `name`                     | String(120) | `name`                | ✅     | Platform name                              |
| `webhook_secret_header`    | String(100) | `webhookSecretHeader` | ✅     |                                            |
| `is_active`                | Boolean     | `isActive`            | ✅     |                                            |
| **aggregator_store_links** |             |                       |        |                                            |
| `id`                       | UUID        | `id`                  | ✅     |                                            |
| `store_id`                 | UUID        | `storeId`             | ✅     |                                            |
| `aggregator_id`            | UUID        | `aggregatorId`        | ✅     |                                            |
| `external_store_id`        | String(255) | `externalStoreId`     | ✅     |                                            |
| `api_key`                  | String(500) | `apiKey`              | ✅     |                                            |
| `api_secret`               | String(500) | `apiSecret`           | ✅     |                                            |
| `config`                   | JSONB       | `config`              | ✅     |                                            |
| `is_enabled`               | Boolean     | `isEnabled`           | ✅     |                                            |
| `created_at`               | DateTime    | `createdAt`           | ✅     |                                            |
| **aggregator_orders**      |             |                       |        |                                            |
| `id`                       | UUID        | —                     | ❌     | No direct UI for aggregator order tracking |
| `external_order_id`        | String(255) | —                     | ❌     |                                            |
| `internal_order_id`        | UUID        | —                     | ❌     | Backend-only mapping                       |
| `external_status`          | String(50)  | —                     | ❌     |                                            |
| `raw_payload`              | JSONB       | —                     | ❌     |                                            |
| **integration_logs**       |             |                       |        |                                            |
| `id`                       | UUID        | `id`                  | ⚠️     | Model exists, log pages render TODO        |
| `store_id`                 | UUID        | `storeId`             | ⚠️     |                                            |
| `aggregator_id`            | UUID        | `aggregatorId`        | ⚠️     |                                            |
| `log_type`                 | String(50)  | `logType`             | ⚠️     |                                            |
| `action`                   | String(100) | `action`              | ⚠️     |                                            |
| `status`                   | String(20)  | `status`              | ⚠️     |                                            |
| `entity_type`              | String(50)  | `entityType`          | ⚠️     |                                            |
| `entity_id`                | UUID        | `entityId`            | ⚠️     |                                            |
| `details`                  | JSONB       | `details`             | ⚠️     |                                            |
| `error_message`            | Text        | `errorMessage`        | ⚠️     |                                            |
| `created_at`               | DateTime    | `createdAt`           | ⚠️     |                                            |

---

## 17. Marketing & Campaigns

**Backend Table**: `campaigns`  
**App Model**: `CampaignModel`  
**App Usage**: ⚠️ **FUTURE** — MarketingRepository has **0 usages** in any screen

| Backend Field      | Type        | App Field         | Status | Notes |
| ------------------ | ----------- | ----------------- | ------ | ----- |
| `id`               | UUID        | `id`              | ⚠️     |       |
| `store_id`         | UUID        | `storeId`         | ⚠️     |       |
| `name`             | String(200) | `name`            | ⚠️     |       |
| `subject`          | String(255) | `subject`         | ⚠️     |       |
| `content`          | Text        | `content`         | ⚠️     |       |
| `target_segment`   | String(30)  | `targetSegment`   | ⚠️     |       |
| `segment_filters`  | JSONB       | `segmentFilters`  | ⚠️     |       |
| `status`           | String(20)  | `status`          | ⚠️     |       |
| `scheduled_at`     | DateTime    | `scheduledAt`     | ⚠️     |       |
| `sent_at`          | DateTime    | `sentAt`          | ⚠️     |       |
| `total_recipients` | Integer     | `totalRecipients` | ⚠️     |       |
| `total_sent`       | Integer     | `totalSent`       | ⚠️     |       |
| `total_opened`     | Integer     | `totalOpened`     | ⚠️     |       |
| `total_clicked`    | Integer     | `totalClicked`    | ⚠️     |       |
| `created_at`       | DateTime    | `createdAt`       | ⚠️     |       |

---

## 18. Notifications

**Backend Tables**: `notifications`, `device_tokens`  
**App Model**: `NotificationModel`  
**App Usage**: ✅ **ACTIVE** — Notification feed (limited usage)

| Backend Field     | Type        | App Field    | Status | Notes                      |
| ----------------- | ----------- | ------------ | ------ | -------------------------- |
| **notifications** |             |              |        |                            |
| `id`              | UUID        | `id`         | ✅     |                            |
| `user_id`         | UUID        | `userId`     | ✅     |                            |
| `store_id`        | UUID        | `storeId`    | ✅     |                            |
| `title`           | String(200) | `title`      | ✅     |                            |
| `body`            | Text        | `body`       | ✅     |                            |
| `category`        | String(50)  | `category`   | ✅     |                            |
| `entity_type`     | String(50)  | `entityType` | ✅     |                            |
| `entity_id`       | UUID        | `entityId`   | ✅     |                            |
| `is_read`         | Boolean     | `isRead`     | ✅     |                            |
| `data`            | JSONB       | `data`       | ✅     |                            |
| `created_at`      | DateTime    | `createdAt`  | ✅     |                            |
| **device_tokens** |             |              |        |                            |
| `id`              | UUID        | —            | 🔄     | Send-only (register token) |
| `user_id`         | UUID        | —            | 🔄     |                            |
| `platform`        | String(20)  | —            | 🔄     | fcm/apns                   |
| `token`           | String(500) | —            | 🔄     | FCM token                  |
| `device_name`     | String(120) | —            | 🔄     |                            |
| `is_active`       | Boolean     | —            | 🔄     |                            |

---

## 19. Audit Logs

**Backend Table**: `audit_logs`  
**App Model**: `AuditLogModel`  
**App Usage**: ⚠️ **FUTURE** — AuditRepository has **0 usages** in any screen

| Backend Field | Type        | App Field     | Status | Notes |
| ------------- | ----------- | ------------- | ------ | ----- |
| `id`          | UUID        | `id`          | ⚠️     |       |
| `store_id`    | UUID        | `storeId`     | ⚠️     |       |
| `user_id`     | UUID        | `userId`      | ⚠️     |       |
| `employee_id` | UUID        | `employeeId`  | ⚠️     |       |
| `action`      | String(100) | `action`      | ⚠️     |       |
| `entity_type` | String(50)  | `entityType`  | ⚠️     |       |
| `entity_id`   | UUID        | `entityId`    | ⚠️     |       |
| `description` | Text        | `description` | ⚠️     |       |
| `old_values`  | JSONB       | `oldValues`   | ⚠️     |       |
| `new_values`  | JSONB       | `newValues`   | ⚠️     |       |
| `ip_address`  | String(45)  | `ipAddress`   | ⚠️     |       |
| `created_at`  | DateTime    | `createdAt`   | ⚠️     |       |

---

## 20. Reports & Analytics

**Backend Tables**: `report_templates`, `report_runs`  
**App Models**: `DashboardStats`, `SalesReportData`, `ReportModel`  
**App Usage**: ✅ **ACTIVE** — Dashboard and Sales Reports

| Backend Field                    | Type        | App Field        | Status | Notes                         |
| -------------------------------- | ----------- | ---------------- | ------ | ----------------------------- |
| **Analytics (custom endpoints)** |             |                  |        |                               |
| `total_sales`                    | Numeric     | `totalSales`     | ✅     | Dashboard KPI                 |
| `net_sales`                      | Numeric     | `netSales`       | ✅     | Dashboard KPI                 |
| `total_orders`                   | Integer     | `totalOrders`    | ✅     | Dashboard KPI                 |
| `gross_sales`                    | Numeric     | `grossSales`     | ✅     | Dashboard KPI                 |
| `tax_collected`                  | Numeric     | `taxCollected`   | ✅     | Dashboard KPI                 |
| `total_discounts`                | Numeric     | `totalDiscounts` | ✅     | Dashboard KPI                 |
| `cash_sales`                     | Numeric     | `cashSales`      | ✅     | Payment breakdown             |
| `card_sales`                     | Numeric     | `cardSales`      | ✅     | Payment breakdown             |
| `upi_sales`                      | Numeric     | `upiSales`       | ✅     | Payment breakdown             |
| `online_sales`                   | Numeric     | `onlineSales`    | ✅     | Payment breakdown             |
| **report_templates**             |             |                  |        |                               |
| `id`                             | UUID        | `id`             | ✅     | Report listing                |
| `code`                           | String(100) | —                | ❌     | Not shown                     |
| `name`                           | String(200) | `title`          | ✅     | Report name                   |
| `description`                    | Text        | `description`    | ✅     |                               |
| `category`                       | String(50)  | `category`       | ✅     |                               |
| `parameters_schema`              | JSONB       | —                | ❌     | Not used by app               |
| `is_active`                      | Boolean     | —                | ❌     |                               |
| **report_runs**                  |             |                  |        |                               |
| All 10 fields                    | —           | —                | ❌     | No report run tracking in app |

---

## 21. Summary & Recommendations

### Overall Statistics

| Category                      | Count |
| ----------------------------- | ----- |
| **Total Backend Tables**      | 50+   |
| **Total Backend Fields**      | ~450+ |
| **App Models (API)**          | 47    |
| **App Models (UI-only)**      | 21    |
| **Fields Actively Used (✅)** | ~150  |
| **Fields Not Needed (❌)**    | ~80   |
| **Fields for Future (⚠️)**    | ~200  |
| **Send-Only Fields (🔄)**     | ~15   |

---

### Actively Required Domains (✅ Keep Fetching)

| Domain             | Priority    | Notes                          |
| ------------------ | ----------- | ------------------------------ |
| **Users & Auth**   | 🔴 Critical | All fields needed              |
| **Stores**         | 🔴 Critical | Most used model (14+ features) |
| **Orders & Items** | 🔴 Critical | Core business operations       |
| **Payments**       | 🟠 High     | Via order sync                 |
| **Employees**      | 🟠 High     | Staff management               |
| **Zones**          | 🟡 Medium   | Delivery zone setup            |
| **Chains**         | 🟡 Medium   | Franchise management           |
| **Integrations**   | 🟡 Medium   | Aggregator status/config       |
| **Notifications**  | 🟢 Low      | Activity feed                  |
| **Analytics**      | 🟡 Medium   | Dashboard & reports            |

### Not Required Domains (❌ Stop Fetching / Don't Build Yet)

| Domain                              | Repo Exists? | UI Exists? | Recommendation                    |
| ----------------------------------- | ------------ | ---------- | --------------------------------- |
| **Audit Logs**                      | Yes          | No         | Don't fetch — no UI to display    |
| **Billing (KOT/Invoice/Templates)** | Yes          | No         | Don't fetch — no UI to display    |
| **Delivery Details**                | Yes          | No         | Don't fetch — no UI to display    |
| **Guests/CRM**                      | Yes          | No         | Don't fetch — no UI to display    |
| **Inventory** (all 9 tables)        | Yes          | No         | Don't fetch — no UI to display    |
| **Ledger/Tax**                      | Yes          | No         | Don't fetch — no UI to display    |
| **Marketing/Campaigns**             | Yes          | No         | Don't fetch — no UI to display    |
| **Menus** (full CRUD)               | Yes          | No         | Don't fetch — no UI to display    |
| **Products** (full CRUD)            | Yes          | No         | Don't fetch — no UI to display    |
| **Shifts & Day Close**              | Yes          | No         | Don't fetch — no UI to display    |
| **Expenses**                        | No           | No         | Backend only — no app code at all |

### Partially Implemented (⚠️ Fix or Remove)

| Feature               | Issue                                             | Recommendation                                  |
| --------------------- | ------------------------------------------------- | ----------------------------------------------- |
| **Permission Groups** | ViewModel fetches, UI renders `SizedBox.shrink()` | **Fix UI** — data already flows, just render it |
| **Pending Purchases** | ViewModel fetches, UI returns TODO                | **Fix UI** — wire the data to list widgets      |
| **Integration Logs**  | Model exists, 3 log pages return empty            | **Fix UI** — render log entries                 |
| **Dine-in Tables**    | Referenced in orders but no management UI         | **Build if needed** — or rely on POS terminal   |
| **POS Terminals**     | Referenced in orders, no management UI            | **Build if needed** — or auto-register          |

### Backend Fields the App Never Needs

These fields exist in the backend but the app has no reason to fetch them:

| Table                | Fields to Skip                                                                | Reason                    |
| -------------------- | ----------------------------------------------------------------------------- | ------------------------- |
| `orders`             | `cancelled_by`, `cancelled_at`, `ledger_account_id`                           | No UI for these           |
| `order_items`        | `cancel_reason`, `kot_id`                                                     | Not shown at item level   |
| `order_table_links`  | All fields                                                                    | No table merge feature    |
| `pos_terminals`      | `device_name`, `device_identifier`, `is_active`, `created_at`                 | No terminal management UI |
| `dine_in_tables`     | `capacity`, `section`, `zone`, `position_x`, `position_y`, `current_order_id` | No table map UI           |
| `expenses`           | All fields                                                                    | No expense UI             |
| `aggregator_orders`  | All fields                                                                    | Backend-only tracking     |
| `report_templates`   | `code`, `parameters_schema`, `is_active`                                      | Not used                  |
| `report_runs`        | All fields                                                                    | No run tracking           |
| `menu_pricing_rules` | All fields                                                                    | No app model exists       |

---

### Network Optimization Recommendations

1. **Remove unused repository calls**: 10 repositories (Audit, Billing, Delivery, Guest, Inventory, Ledger, Marketing, Menu, Product, Shift) are registered but never called — consider lazy-loading them only when UI is built
2. **Slim API responses**: For orders list view, return only summary fields (`id`, `orderNumber`, `status`, `netAmount`, `orderType`, `createdAt`) and load details on tap
3. **Add pagination**: Currently all lists fetch without cursor/offset pagination
4. **Add local caching**: App has zero offline capability — consider caching stores, products, and menus locally since they change infrequently
5. **Batch store data**: Dashboard loads store data repeatedly — consider a combined `/dashboard/init` endpoint

---

_This document should be updated whenever new features are implemented in the app or new backend models are added._
