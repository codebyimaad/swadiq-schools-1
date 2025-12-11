
import psycopg2
import sys
from faker import Faker

# --- DATABASE CONNECTION DETAILS ---
# Taken from your app/config/config.go file
DB_HOST = "129.80.85.203"
DB_PORT = 5432
DB_NAME = "swadiq"
DB_USER = "imaad"
DB_PASSWORD = "Ertdfgxc"
# -----------------------------------

def create_parent_in_db(conn, first_name, last_name, phone=None, email=None, address=None):
    """
    Uses an existing database connection to insert a new parent directly.
    """
    try:
        # Create a cursor
        cur = conn.cursor()

        # The SQL query to insert a new parent, returning the new parent's ID
        query = """
            INSERT INTO parents (first_name, last_name, phone, email, address, is_active, created_at, updated_at) 
            VALUES (%s, %s, %s, %s, %s, true, NOW(), NOW()) 
            RETURNING id;
        """

        # Execute the query with the provided parent details
        cur.execute(query, (first_name, last_name, phone, email, address))
        
        # Fetch the returned ID
        new_parent_id = cur.fetchone()[0]
        
        # Commit the transaction
        conn.commit()
        
        print(f"Successfully created parent: {first_name} {last_name} (ID: {new_parent_id})")

        # Close the cursor
        cur.close()

    except psycopg2.Error as e:
        print(f"Database error for parent '{first_name} {last_name}': {e}", file=sys.stderr)
        # Rollback the transaction on error
        conn.rollback()

if __name__ == "__main__":
    try:
        num_parents_str = input("Enter the number of parents you want to create: ")
        num_parents = int(num_parents_str)
        if num_parents <= 0:
            print("Please enter a positive number.")
            sys.exit(1)
    except ValueError:
        print("Invalid input. Please enter a number.")
        sys.exit(1)

    # Initialize Faker
    fake = Faker()

    conn = None
    try:
        # Establish a single database connection
        conn = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT
        )
        print(f"Database connection successful. Creating {num_parents} parent(s)...")

        # Loop to create the specified number of parents
        for i in range(num_parents):
            print(f"\nGenerating parent {i+1} of {num_parents}...")
            create_parent_in_db(
                conn=conn,
                first_name=fake.first_name(),
                last_name=fake.last_name(),
                phone=fake.phone_number(),
                email=fake.unique.email(),
                address=fake.address().replace('\n', ', ')
            )

    except psycopg2.Error as e:
        print(f"Failed to connect to the database: {e}", file=sys.stderr)

    finally:
        # Close the connection
        if conn:
            conn.close()
            print("\nDatabase connection closed.")
