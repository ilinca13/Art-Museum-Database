# Art Museum Database Management System

![Oracle](https://img.shields.io/badge/Database-Oracle%20XE-F80000?logo=oracle&logoColor=white)
![SQL](https://img.shields.io/badge/Language-SQL%20%2F%20PLSQL-336791)
![C#](https://img.shields.io/badge/Language-C%23-239120?logo=csharp&logoColor=white)
![WinForms](https://img.shields.io/badge/UI-Windows%20Forms-0078D4)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

This repository contains a **relational database** project for managing the operations of an **Art museum**, developed as a semester project for my **Databases** course (2nd Year, 1st Semester).

The project covers the full database lifecycle: modeling a real-world process, designing a normalized schema around it, implementing that schema in **Oracle XE** using Oracle SQL Developer with full integrity enforcement, and building a **desktop application** (**Windows Forms**) that exposes the data to an end user without requiring any SQL knowledge from them.

The final schema has **21 tables** (14 core entities plus 7 associative tables for many-to-many relationships), enforced through primary keys, foreign keys, `UNIQUE`, `NOT NULL`, and `CHECK` constraints, with cascading deletes applied wherever a dependent record has no meaning on its own.

## Project Files

This project follows the structure of the original assignment and is organized into **two** complementary parts: the **database design and implementation**, and the **interactive desktop application** built on top of it. The files below correspond to each part, together with the original requirements that defined the project's main goals.
 
| File | Description |
|---|---|
| [**Project Requirements**](./cerinte_Proiect.pdf) | Complete Project Requirements. |
| [**Complete Database Documentation**](./Horeangă_Ilinca_262_Documentație_Gestionare_Muzeu_de_Artă.pdf) | **Full report** covering the database part: real-world model, **ER diagram**, **conceptual diagram**, entity and constraint descriptions, **relational schemas**, and the complete SQL implementation. |
| [**SQL Script**](./Horeanga_Ilinca_Muzeu_Arta_Script.sql) | Table creation, constraints, and sample data. |
| [**Desktop application**](./Template_Capitolul_III_Horeangă_Ilinca_262.pdf) | Write-up of the **desktop interface**, covering each interactivity requirement with explanations and code excerpts. |
| [**SQL Labs**](./SQL%20Labs) | Reference materials and exercises covering the SQL concepts needed throughout the project. |


## Entity-Relationship Diagram

<img width="600" height="379" alt="image" src="https://github.com/user-attachments/assets/6499c1f8-27b6-44ea-9a42-64274882a77a" />

## Logical / Conceptual Diagram

>The diagram below was generated directly from **Oracle SQL Developer**'s **Data Modeler**, based on the implemented schema.

<img width="735" height="870" alt="image" src="https://github.com/user-attachments/assets/14c463ee-210c-48dd-b2b4-83d27143586c" />

## Real-World Model

The database manages the core operations of an art museum: visitors and ticketing, exhibitions and the rooms they occupy, guided tours, curators and guides, artists and the artistic movements they belong to, collections and the collectors who own them, and the artworks themselves.

Key business rules captured in the model include:

- Each visitor is uniquely identified by a national ID (CNP) and can purchase one or more tickets; a ticket belongs to exactly one visitor.
- Each ticket is tied to a single payment method, and a ticket may grant access to one or more current exhibitions.
- Employees can take on the role of curator or guide, modeled as an ISA/specialization relationship rather than duplicating shared attributes.
- Curators organize exhibitions; an exhibition belongs to at most one active curator, but a curator may run zero or many exhibitions.
- Guides can lead multiple different tours, and the same tour can be run multiple times (or simultaneously) by the same or different guides — captured through a dedicated scheduling table rather than a direct link.
- Collectors lend or donate one or more collections to the museum; each collection belongs to exactly one collector.
- A collection holds multiple artworks, but each artwork belongs to exactly one collection — so an artwork's exhibition eligibility depends on its parent collection's availability window.
- Artists can be linked to one or more artistic movements with varying degrees of involvement, and artworks may have multiple contributing artists (collaborative pieces) or a single, possibly unknown, author.
- Rooms can be allocated to both exhibitions and special tours, and a single room can host different exhibitions or tours over time.
- Referential integrity is enforced through foreign keys and `CHECK` constraints throughout, and deleting a principal entity automatically removes dependent records where that dependency is total (`ON DELETE CASCADE`).


## Database Design and Implementation

The first phase of the project was entirely about modeling and implementing the database itself, independent of any user interface.

### Modeling

- Identifying entities, attributes, and relationships from the real-world museum scenario, including which relationships needed full participation (minimum cardinality 1) versus optional participation (minimum cardinality 0) on each side.
- Modeling the `Employee` hierarchy with `Curator` and `Guide` as specializations sharing the same primary key (`Angajat_ID`) as their parent, rather than duplicating employee attributes: an ISA relationship with disjoint, partial specialization.
- Designing 7 associative tables with composite primary keys to represent many-to-many relationships that themselves carry attributes: for example, `Tour_Scheduling` (which tour, which guide, on which date, with how many participants) needed all three identifying columns in its primary key, since the same guide could run the same tour on different dates.
- Deriving final relational schemas for all 21 tables directly from the conceptual model, keeping attribute names, types, and nullability consistent with the ER-level specification.

### Implementation in Oracle Database XE

- Creating all 14 core entities and 7 associative tables via `CREATE TABLE` statements, generally separating constraint definitions into `ALTER TABLE ... ADD CONSTRAINT` statements for clarity and easier iteration during development.
- Defining primary keys (simple on core entities, composite on associative tables), foreign keys, `UNIQUE` constraints (e.g., on visitor and employee email addresses), and `NOT NULL` constraints on attributes that are mandatory by the model's cardinalities.
- Adding `CHECK` constraints for data validation, including:
  - Format and length validation on the visitor's CNP (Romanian national ID), checking both the leading digit and the total length.
  - Enumerated value restrictions on categorical attributes — ticket discount type, room operating status, exhibition type, tour type, collector category and collaboration type, ticket access level, and artwork display type (original, reproduction, or 3D model).
  - Date-range sanity checks, such as ensuring an artist's death date is never earlier than their birth date, a collection's availability window is internally consistent, or an exhibition's end date is never earlier than its start date.
- Applying `ON DELETE CASCADE` wherever a dependent record has no independent meaning — for example, a `Curator` or `Guide` row without its underlying `Employee` record, or any associative-table row once either of its parent entities is removed (an artist's movement involvement, a tour's room allocation, a ticket's exhibition access details, and so on).
- Choosing `DEFAULT` values where the model called for a sensible fallback rather than a mandatory user input — for instance, a ticket's discount type defaulting to full price, a room defaulting to an operational status, or an artwork defaulting to being displayed as an original.
- Populating every table with representative sample data that exercises each relationship at least once, including edge cases such as a collaborative artwork with two contributing artists, an artist linked to two different movements, and a collection with no defined end date (an open-ended loan).
- Writing teardown scripts that drop foreign key constraints first, then drop tables in dependency order with `CASCADE CONSTRAINTS`, allowing the entire schema to be rebuilt cleanly from scratch.

This phase corresponds to sections I and II of the project requirements and is fully documented in the [Database Documentation](./Horeangă_Ilinca_262_Documentație_Gestionare_Muzeu_de_Artă.pdf) and implemented in the [SQL Script](./Horeanga_Ilinca_Muzeu_Arta_Script.sql).

---

## Interface Implementation

Once the database was complete, a separate **C# Windows Forms** desktop application was built on top of it to satisfy the interactivity requirements of the assignment (section III). This phase was about exposing the already-implemented database to an end user through a generic, reusable interface — not about further modeling.

The application connects to Oracle XE through **Oracle.ManagedDataAccess (ODP.NET)**, and was deliberately built to work against *any* table or view in the schema rather than hardcoding logic per table.

### Generic table browsing, sorting, and metadata discovery

Rather than writing separate UI logic for each of the 21 tables, the application queries Oracle's own data dictionary at runtime:

- On startup, a dropdown is populated with every table and view name in the schema.
- When a table is selected, its column names are retrieved dynamically from `USER_TAB_COLUMNS` (ordered by `COLUMN_ID`) and used to populate a second dropdown.
- Loading a table runs a plain `SELECT * FROM {table}` through an `OracleDataAdapter` into a `DataTable`, which is then bound to a `DataGridView`.
- Sorting is implemented the same generic way: the selected table and column are interpolated into a `SELECT * FROM {table} ORDER BY {column} ASC` query, so sorting works identically regardless of which table or column is chosen.

### Editing and deletion

- Cell values can be edited directly in the grid. Changes are tracked in-memory by the bound `DataTable` until explicitly saved.
- Saving calls `OracleCommandBuilder`, which inspects the table's primary key and automatically generates the correct `UPDATE` statement for whichever rows were modified — no manual SQL is written per table.
- Deleting a row marks it for removal in the `DataTable` and applies the change through the same adapter; if the deletion violates a constraint the database rejects it and the error is surfaced back to the user (`dt.RejectChanges()` is used to roll back the pending change locally) rather than silently failing.
- Because `OracleCommandBuilder` derives its logic from the primary key, this same generic editing and deletion flow works correctly across both single-column primary keys (e.g., `Vizitator`) and composite primary keys on associative tables (e.g., `Implicare_Curent`).

### Multi-table filtered query

A dedicated query joins four tables — `Vizitator`, `Bilet`, `Detalii_Bilet`, and `Expozitie` — to answer a concrete business question: which visitors bought tickets priced above 20 for temporary exhibitions that started after a given date. The query applies two independent filter conditions (price threshold and exhibition type/date) on top of the three joins, and results are ordered by visitor name.

### Aggregate query with GROUP BY / HAVING

A second dedicated query answers a reporting question that can't be expressed without aggregation: which guides have led at least two tours with a combined attendance above 10 participants. It joins `Programare_Tur`, `Ghid`, `Angajat`, and `Tur_Special`, groups by guide name using `COUNT(Tur_ID)` and `SUM(Numar_Participanti)`, and filters the *aggregated* results with a `HAVING` clause — illustrating the distinction between filtering rows (`WHERE`) and filtering grouped results (`HAVING`).

### Live ON DELETE CASCADE demonstration

The cascading-delete behavior defined at the schema level is demonstrated directly through the interface rather than just described in documentation: deleting a record from `Curent_Artistic` (an artistic movement) and then reloading the dependent `Implicare_Curent` table shows that the corresponding rows were removed automatically by Oracle, without any explicit delete being issued against the associative table.

### Views with different update semantics

The project deliberately includes two views that behave very differently, to illustrate when a view can support data modification and when it can't:

| View | Type | Tables involved | Supports editing? | Purpose |
|---|---|---|---|---|
| `Viz_Bilete_Plata` | Composite, updatable | `Bilet`, `Metoda_Plata` (simple join) | Yes: key-preserved table | Unified view of tickets with their payment method details |
| `Viz_Opere_Expozitie` | Complex, analytical | `Expozitie`, `Alocare_Opera_Expozitie`, `Opera`, `Colectie`, `Colectionar`, `Contributie_Artist`, `Artist` (multi-join, filtered, ordered) | No: aggregation and window functions | Reporting view showing artworks on display per exhibition, with collector and artist details and a running count of artworks per exhibition via `COUNT(...) OVER (PARTITION BY ...)` |

Both views are exposed through the same generic table-browsing mechanism described above - from the application's point of view, a view is just another entry in the table dropdown. Editing only succeeds against `Viz_Bilete_Plata`, since `OracleCommandBuilder` can trace its rows back to a single key-preserved base table (`Bilet`); attempting the same against `Viz_Opere_Expozitie` would fail, since its joins, aggregation, and analytic functions make it impossible for Oracle to determine which base row a given change should apply to.

This phase is fully documented in the [Application Layer Documentation](./Template_Capitolul_III_Horeangă_Ilinca_262.pdf).

---

## Tech Stack

- **Oracle Database Express Edition (XE)**: relational database engine, table design, constraints, and views.
- **Oracle SQL Developer**: schema development, querying, and ER/conceptual diagram generation.
- **C# / .NET Framework (Windows Forms)**: desktop application for end-user interaction.
- **Oracle.ManagedDataAccess (ODP.NET)**: database connectivity layer between the C# application and Oracle, including `OracleDataAdapter` and `OracleCommandBuilder` for generic, metadata-driven CRUD operations.
