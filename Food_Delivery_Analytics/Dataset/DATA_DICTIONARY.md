# Food Delivery Analytics Dataset

This is a synthetic learning dataset for a portfolio project. It does not represent a real company.

## Files
- customers.csv: customer profile information
- restaurants.csv: restaurant details and cuisine
- delivery_partners.csv: delivery partner details
- orders.csv: 15,000 order records
- ratings.csv: customer reviews for a subset of delivered orders

## Expected order counts
- Total orders: 15,000
- Delivered: 13,673
- Cancelled: 1,327

## Import note
All columns are populated. For cancelled orders, actual_delivery_minutes and preparation_time_minutes are set to 0, cancellation_reason contains the cancellation reason, and partner_id is a valid partner ID. This avoids blank values and missing foreign-key references during beginner-level CSV import into MySQL Workbench.

## Table relationships
- orders.customer_id -> customers.customer_id
- orders.restaurant_id -> restaurants.restaurant_id
- orders.partner_id -> delivery_partners.partner_id
- ratings.order_id -> orders.order_id
- ratings.customer_id -> customers.customer_id
- ratings.restaurant_id -> restaurants.restaurant_id
