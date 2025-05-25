# Housing Management System

A web-based housing management system built with ASP.NET that helps manage properties, rentals, and sales.

## Features

- Property listing and management
- Rental property management
- Property sales management
- User authentication and authorization
- Admin dashboard
- Society management
- Member management

## Prerequisites

- Visual Studio 2019 or later
- SQL Server 2019 or later
- .NET Framework 4.7.2 or later
- IIS Express

## Installation

1. Clone the repository:
```bash
git clone [your-repository-url]
```

2. Open the solution in Visual Studio

3. Update the connection string in Web.config to point to your SQL Server instance

4. Run the database setup script (database_setup.sql) in SQL Server Management Studio

5. Build and run the project

## Database Setup

1. Create a new database named "HHelp"
2. Run the database_setup.sql script to create all necessary tables and stored procedures
3. The script will also insert some sample data for testing

## Running the Project

1. Open the solution in Visual Studio
2. Press F5 or click the "Start" button to run the project
3. The application will open in your default web browser at http://localhost:44300

## Project Structure

- `/Admin` - Admin panel pages
- `/Member` - Member-related pages
- `/img` - Image assets
- `/engine1` - Slider engine files
- `database_setup.sql` - Database setup script

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details 