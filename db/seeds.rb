# Create admin user
puts "Creating admin user..."
admin = User.where(email: 'admin@example.com').first_or_initialize
admin.password = 'password123'
admin.role = 'admin'
admin.save!
puts "Admin user created: #{admin.email}"
