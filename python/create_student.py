import psycopg2
import sys
import datetime
from faker import Faker

# --- DATABASE CONNECTION DETAILS ---
DB_HOST = "129.80.85.203"
DB_PORT = 5432
DB_NAME = "swadiq"
DB_USER = "imaad"
DB_PASSWORD = "Ertdfgxc"
# -----------------------------------

# --- PREDEFINED LISTS ---
RELATIONSHIPS = ["Father", "Mother", "Guardian", "Brother", "Sister", "Other"]
# ------------------------

def get_parents(conn):
    """Fetches all parents from the database."""
    parents = []
    try:
        cur = conn.cursor()
        cur.execute("SELECT id, first_name, last_name FROM parents WHERE is_active = true ORDER BY first_name, last_name")
        parents = cur.fetchall()
        cur.close()
    except psycopg2.Error as e:
        print(f"Database error while fetching parents: {e}", file=sys.stderr)
    return parents

def get_classes(conn):
    """Fetches all active classes from the database."""
    classes = []
    try:
        cur = conn.cursor()
        cur.execute("SELECT id, name, code FROM classes WHERE is_active = true ORDER BY name")
        classes = cur.fetchall()
        cur.close()
    except psycopg2.Error as e:
        print(f"Database error while fetching classes: {e}", file=sys.stderr)
    return classes

def get_next_student_number(cur, year):
    """Gets the next sequential number for a student ID for the given year."""
    year_prefix = f"STU-{year}-%"
    cur.execute("SELECT student_id FROM students WHERE student_id LIKE %s ORDER BY student_id DESC LIMIT 1", (year_prefix,))
    last_id = cur.fetchone()
    if not last_id:
        return 1
    try:
        last_number = int(last_id[0].split('-')[-1])
        return last_number + 1
    except (IndexError, ValueError):
        return 1

def generate_student_id(cur):
    """Generates a unique student ID in the format STU-YYYY-XXX."""
    current_year = datetime.datetime.now().year
    next_number = get_next_student_number(cur, current_year)
    return f"STU-{current_year}-{next_number:03d}"

def create_student_and_link_parent(conn, student_data, parent_id, relationship, class_id):
    """Creates a student and links them to a parent and class in a single transaction."""
    try:
        cur = conn.cursor()

        student_id = generate_student_id(cur)

        student_query = """
            INSERT INTO students (student_id, first_name, last_name, date_of_birth, gender, address, class_id, is_active, created_at, updated_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s, true, NOW(), NOW())
            RETURNING id;
        """
        cur.execute(student_query, (
            student_id, 
            student_data['first_name'], 
            student_data['last_name'], 
            student_data['dob'], 
            student_data['gender'], 
            student_data['address'],
            class_id
        ))
        new_student_id = cur.fetchone()[0]

        link_query = """
            INSERT INTO student_parents (student_id, parent_id, relationship, is_primary, created_at, updated_at)
            VALUES (%s, %s, %s, true, NOW(), NOW());
        """
        cur.execute(link_query, (new_student_id, parent_id, relationship))

        conn.commit()
        print(f"Successfully created student '{student_data['first_name']} {student_data['last_name']}' (ID: {student_id}) and linked to parent and class.")
        cur.close()

    except psycopg2.Error as e:
        print(f"Database error during student creation: {e}", file=sys.stderr)
        conn.rollback()

if __name__ == "__main__":
    conn = None
    try:
        conn = psycopg2.connect(
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port=DB_PORT
        )
        print("Database connection successful.")

        parents = get_parents(conn)
        if not parents:
            print("No parents found. Please create parents first.")
            sys.exit(1)

        classes = get_classes(conn)
        if not classes:
            print("No classes found. Please create classes first.")
            sys.exit(1)

        try:
            num_students_str = input("Enter the number of students to create: ")
            num_students = int(num_students_str)
            if num_students <= 0:
                print("Please enter a positive number.")
                sys.exit(1)
        except ValueError:
            print("Invalid input. Please enter a number.")
            sys.exit(1)

        fake = Faker()

        for i in range(num_students):
            print(f"\n--- Creating Student {i+1} of {num_students} ---")
            
            # Select Class
            print("Please select a class:")
            for idx, cls in enumerate(classes):
                print(f"  {idx + 1}: {cls[1]} ({cls[2]}) ")
            while True:
                try:
                    class_choice_str = input(f"Enter class number (1-{len(classes)}): ")
                    class_choice = int(class_choice_str) - 1
                    if 0 <= class_choice < len(classes):
                        selected_class_id = classes[class_choice][0]
                        break
                    else:
                        print("Invalid number. Please try again.")
                except ValueError:
                    print("Invalid input. Please enter a number.")

            # Select Parent
            print("\nPlease select a parent:")
            for idx, parent in enumerate(parents):
                print(f"  {idx + 1}: {parent[1]} {parent[2]}")
            while True:
                try:
                    parent_choice_str = input(f"Enter parent number (1-{len(parents)}): ")
                    parent_choice = int(parent_choice_str) - 1
                    if 0 <= parent_choice < len(parents):
                        selected_parent_id = parents[parent_choice][0]
                        break
                    else:
                        print("Invalid number. Please try again.")
                except ValueError:
                    print("Invalid input. Please enter a number.")

            # Select Relationship
            print("\nPlease select a relationship:")
            for idx, rel in enumerate(RELATIONSHIPS):
                print(f"  {idx + 1}: {rel}")
            while True:
                try:
                    rel_choice_str = input(f"Enter relationship number (1-{len(RELATIONSHIPS)}): ")
                    rel_choice = int(rel_choice_str) - 1
                    if 0 <= rel_choice < len(RELATIONSHIPS):
                        selected_relationship = RELATIONSHIPS[rel_choice]
                        break
                    else:
                        print("Invalid number. Please try again.")
                except ValueError:
                    print("Invalid input. Please enter a number.")

            student_data = {
                'first_name': fake.first_name(),
                'last_name': fake.last_name(),
                'dob': fake.date_of_birth(minimum_age=5, maximum_age=18),
                'gender': fake.random_element(elements=('male', 'female')),
                'address': fake.address().replace('\n', ', ')
            }

            create_student_and_link_parent(conn, student_data, selected_parent_id, selected_relationship, selected_class_id)

    except psycopg2.Error as e:
        print(f"Database connection failed: {e}", file=sys.stderr)

    finally:
        if conn:
            conn.close()
            print("\nDatabase connection closed.")