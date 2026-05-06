import mysql.connector
from mysql.connector import Error
from getpass import getpass


def connect():
    return mysql.connector.connect(
        host="localhost",
        port=3306,
        user=input("MySQL username: "),
        password=getpass("MySQL password: "),
        database="urms"
    )


def show_sponsors(conn):
    print("\n--- SELECT: Showing first 5 sponsors ---")
    sql = """
        SELECT sponsor_id, sponsor_name, sponsor_type, contact_email
        FROM Sponsor
        ORDER BY sponsor_id
        LIMIT 5
    """

    cursor = conn.cursor(dictionary=True)
    cursor.execute(sql)

    for row in cursor.fetchall():
        print(row)

    cursor.close()


def insert_sponsor(conn):
    print("\n--- INSERT: Adding a new sponsor using prepared statement ---")

    sql = """
        INSERT INTO Sponsor (sponsor_name, sponsor_type, contact_email)
        VALUES (%s, %s, %s)
    """

    values = (
        "URMS Demo Research Foundation",
        "Nonprofit",
        "demo.foundation@urms.edu"
    )

    cursor = conn.cursor()
    cursor.execute(sql, values)
    conn.commit()

    new_id = cursor.lastrowid
    print(f"Inserted sponsor with sponsor_id = {new_id}")

    cursor.close()
    return new_id


def update_sponsor(conn, sponsor_id):
    print("\n--- UPDATE: Updating sponsor email using prepared statement ---")

    sql = """
        UPDATE Sponsor
        SET contact_email = %s
        WHERE sponsor_id = %s
    """

    values = (
        "updated.demo.foundation@urms.edu",
        sponsor_id
    )

    cursor = conn.cursor()
    cursor.execute(sql, values)
    conn.commit()

    print(f"Updated sponsor_id = {sponsor_id}")
    cursor.close()


def delete_sponsor(conn, sponsor_id):
    print("\n--- DELETE: Deleting demo sponsor using prepared statement ---")

    sql = """
        DELETE FROM Sponsor
        WHERE sponsor_id = %s
    """

    cursor = conn.cursor()
    cursor.execute(sql, (sponsor_id,))
    conn.commit()

    print(f"Deleted sponsor_id = {sponsor_id}")
    cursor.close()


def run_transaction(conn):
    print("\n--- TRANSACTION: Insert grant and expense together ---")

    cursor = conn.cursor()

    try:
        conn.start_transaction()

        # Get one existing project so the foreign key is valid.
        cursor.execute("""
            SELECT project_id
            FROM ResearchProject
            ORDER BY project_id
            LIMIT 1
        """)
        project = cursor.fetchone()

        if not project:
            raise Exception("No research project found. Seed data is required.")

        project_id = project[0]

        # Insert sponsor for this transaction.
        cursor.execute("""
            INSERT INTO Sponsor (sponsor_name, sponsor_type, contact_email)
            VALUES (%s, %s, %s)
        """, (
            "Transaction Demo Sponsor",
            "Internal",
            "transaction.demo@urms.edu"
        ))

        sponsor_id = cursor.lastrowid

        # Insert grant.
        cursor.execute("""
            INSERT INTO ProjectGrant
                (sponsor_id, project_id, grant_title, award_amount, award_date, grant_status)
            VALUES
                (%s, %s, %s, %s, CURDATE(), %s)
        """, (
            sponsor_id,
            project_id,
            "Transaction Demo Grant",
            50000.00,
            "Awarded"
        ))

        grant_id = cursor.lastrowid

        # Insert expense connected to that grant.
        cursor.execute("""
            INSERT INTO Expense
                (grant_id, expense_date, category, amount, description)
            VALUES
                (%s, CURDATE(), %s, %s, %s)
        """, (
            grant_id,
            "Equipment",
            2500.00,
            "Transaction demo equipment purchase"
        ))

        conn.commit()

        print("Transaction committed successfully.")
        print(f"Created sponsor_id = {sponsor_id}")
        print(f"Created grant_id = {grant_id}")
        print("Created one expense linked to the grant.")

    except Exception as e:
        conn.rollback()
        print("Transaction failed. Rolled back changes.")
        print(f"Error: {e}")

    finally:
        cursor.close()


def main():
    try:
        conn = connect()

        print("\nConnected to the URMS MySQL database.")

        show_sponsors(conn)

        sponsor_id = insert_sponsor(conn)
        show_sponsors(conn)

        update_sponsor(conn, sponsor_id)
        show_sponsors(conn)

        delete_sponsor(conn, sponsor_id)
        show_sponsors(conn)

        run_transaction(conn)

        conn.close()
        print("\nApplication demo completed.")

    except Error as e:
        print(f"MySQL error: {e}")


if __name__ == "__main__":
    main()
