# Acme Basket - E-commerce Application

Acme Basket is a modern e-commerce application built with Ruby on Rails that provides a complete shopping experience from product browsing to checkout.

## Features

- **Product Catalog**: Browse and search through available products
- **User Authentication**: Secure login and registration using Devise
- **Shopping Cart**: Add products to cart, update quantities, and remove items
- **Special Offers**: "Buy one, get the second half price" discount for eligible products
- **Dynamic Shipping Costs**: Tiered shipping rates based on order subtotal
  - Orders under $50: $4.95 shipping
  - Orders between $50-$90: $2.95 shipping
  - Orders over $90: Free shipping
- **Order Management**: View order history and details
- **Responsive Design**: Mobile-friendly interface using Bootstrap
- **Role-Based Access Control**: Admin and customer roles with different permissions

## Future Enhancements

### Inventory Management
In a future phase, we plan to implement inventory management functionality:
- Track available quantity for each product
- Automatically adjust inventory when orders are placed
- Flag products with low inventory for restocking
- Allow admins to manage inventory levels
- Mark out-of-stock products as unavailable for purchase

## Technical Stack

- **Framework**: Ruby on Rails
- **Database**: PostgreSQL
- **Authentication**: Devise
- **Authorization**: Pundit
- **Frontend**: Bootstrap 5

## Models

- **Product**: Product catalog with name, description, price, and inventory
- **User**: Authentication using Devise with role-based access (admin/customer)
- **Cart**: Shopping cart before checkout
- **CartItem**: Items in a cart with product, quantity, and price
- **Order**: Completed purchases after checkout
- **OrderLineItem**: Items in an order with product, quantity, and price

## Shopping Flow

1. User browses products and adds items to cart
2. Cart is created or updated with cart items
3. Cart items store product price in cents and quantity
4. User proceeds to checkout
5. On successful checkout, cart is marked as checked out
6. Order is created with line items copied from cart items
7. User can view order history and details

## Special Offers

Acme Basket supports a "Buy one, get the second half price" special offer feature:

### For Administrators

1. **Enabling Special Offers**: When creating or editing a product, check the "Special Offer" checkbox to enable the discount for that product.
2. **Managing Special Offers**: Products with special offers are clearly marked in the product listing with a "Special Offer" badge.

### For Customers

1. **Identifying Special Offers**: Products with special offers are marked with a "Special Offer" badge on both the product listing and detail pages.
2. **How the Discount Works**:
   - When a customer adds 2 or more of the same special offer product to their cart, the discount is automatically applied.
   - For every pair of items, one is charged at full price and one at half price.
   - For odd quantities (e.g., 3 items), the discount applies to pairs (so 1 full price, 1 half price, 1 full price).
3. **Savings Display**: The cart and order pages show the savings amount from special offers.

## Setup

### Prerequisites

- Ruby 3.0.0 or higher
- Rails 7.0.0 or higher
- PostgreSQL

### Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/acme_basket.git
   cd acme_basket
   ```

2. Install dependencies
   ```
   bundle install
   ```

3. Setup database
   ```
   rails db:create
   rails db:migrate
   ```

4. Seed the database with sample data and admin user
   ```
   rails db:seed
   ```
   
   This will create an admin user with the following credentials:
   - Email: admin@example.com
   - Password: password123

5. Start the server
   ```
   rails server
   ```

6. Visit `http://localhost:3000` in your browser

### User Roles

The application has two types of users:

1. **Admin Users**:
   - Can manage (create, edit, delete) products
   - Can view all orders in the system
   - Have access to administrative functions
   - Login using the seeded admin account: admin@example.com / password123

2. **Customer Users**:
   - Can browse products and add them to cart
   - Can checkout and place orders
   - Can view their own order history
   - Register a new account

## Development

### Running Tests

```
bundle exec rspec spec
```
