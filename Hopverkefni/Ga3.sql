


--- Dæmi 1 ---

CREATE OR REPLACE VIEW AllAccountRecords
AS
  SELECT a.aid, a.pid, a.adate, a.abalance, a.aover
  FROM accounts a, accountrecords ar
  WHERE a.aid in (
    SELECT ar2.aid
    FROM
    accountrecords ar2
    )
  GROUP BY a.pid, a.aid;


SELECT * FROM AllAccountRecords;


--- Dæmi 2 ---

CREATE OR REPLACE VIEW DebtorStatus
AS
  SELECT DISTINCT p.pid, p.pname, a.abalance
  FROM people p
  INNER JOIN accounts a ON p.pid = a.pid
  WHERE a.abalance < 0
  GROUP BY p.pid, a.abalance;


SELECT * FROM DebtorStatus;


--- Dæmi 3 ---


CREATE OR REPLACE VIEW FinancialStatus
AS
  SELECT p.pid, p.pname, SUM(a.abalance) as total_balance, SUM(b.bamount) as unpaid
  FROM people p
  INNER JOIN accounts a on p.pid = a.pid
  INNER JOIN bills b on p.pid = b.pid
  WHERE b.bispaid = 'f'
  GROUP BY p.pid
  HAVING COUNT(a.pid) > 1;


SELECT * FROM FinancialStatus;



--- Dæmi 4 ---


CREATE OR REPLACE FUNCTION CheckBills()
RETURNS TRIGGER
AS $$
  BEGIN
    IF( NEW.bduedate < CURRENT_DATE) THEN
      RAISE EXCEPTION 'Due date cant be later than today´s date' USING ERRCODE = '45000';
    end if;
    IF (NEW.bamount < 0) THEN
      RAISE EXCEPTION 'Bills cannot have a negative amount' USING ERRCODE = '45000';
    end if;
    IF (TG_OP = 'DELETE') THEN
      RAISE EXCEPTION 'Cannot delete' USING ERRCODE = '45000';
    end if;
    IF (TG_OP = 'UPDATE') THEN
        IF (bispaid != 'F' OR bispaid != 'T') THEN
          ABORT TRANSACTION;
        end if;
    END IF;
  end;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS CheckBills on bills;

CREATE TRIGGER CheckBills
  BEFORE INSERT OR DELETE OR UPDATE OF bduedate, bamount ON bills
  FOR EACH ROW
  EXECUTE PROCEDURE CheckBills();


BEGIN;
  INSERT INTO bills (bduedate, bamount, bispaid) VALUES ('1999-01-01', 10000, 'F');

SELECT * FROM bills;

DELETE FROM bills
WHERE bduedate = '1999-01-01';


--- Dæmi 5 ---


CREATE OR REPLACE FUNCTION CheckAccountRecords()
RETURNS TRIGGER
AS
$$
  BEGIN
    IF (NEW.ramount < (SELECT a.aover + a.abalance FROM accounts a WHERE a.aid = NEW.aid)) THEN
      RAISE EXCEPTION 'Cannot withdraw' USING ERRCODE = '45000';
    end if;
    IF (NEW.ramount >= (SELECT a.aover + a.abalance FROM accounts a WHERE a.aid = NEW.aid)) THEN
      INSERT INTO accounts (abalance) VALUES (NEW.ramount - (abalance + aover));
    end if;
  end;
$$
LANGUAGE plpgsql;



DROP TRIGGER IF EXISTS CheckAccountRecords ON AccountRecords;

CREATE TRIGGER CheckAccountRecords
  BEFORE INSERT OR DELETE OR UPDATE ON accountrecords
  FOR EACH ROW
  EXECUTE PROCEDURE CheckAccountRecords();

BEGIN;
UPDATE accounts SET abalance = abalance - 100.00
    WHERE pid = 1;
SAVEPOINT my_savepoint;
ROLLBACK TO my_savepoint;

SELECT * FROM accounts;

--- Dæmi 6 ---

DROP FUNCTION IF EXISTS StartNewAccount();

CREATE OR REPLACE FUNCTION StartNewAccount()
RETURNS VOID
AS
$$
  BEGIN
    INSERT INTO accounts (SELECT abalance FROM accounts a, people p WHERE a.aid = p.pid);
  end;
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS NewPerson on people;

CREATE TRIGGER NewPerson
  AFTER INSERT ON people
  EXECUTE PROCEDURE StartNewAccount();



--- Dæmi 7 ---


CREATE OR REPLACE FUNCTION InsertPerson(iName varchar(30), iGender varchar(1), iHeight FLOAT, iAmount INT)
RETURNS VOID
AS
$$
  BEGIN
    INSERT INTO people (pname, pgender, pheight) VALUES (iName, iGender, iHeight);
    INSERT INTO accounts (abalance) VALUES (iAmount);
  end;
$$
LANGUAGE plpgsql;


SELECT InsertPerson('Hélgi', 'J',1.60,1000000);





DROP FUNCTION IF EXISTS FindBogusAccounts();
CREATE FUNCTION FindBogusAccounts()
RETURNS TABLE (AID INTEGER, PID INTEGER, aDate DATE, aBalance INTEGER, aOver INTEGER)
AS
  $$
  SELECT *
  FROM Accounts A
  WHERE (A.aBalance <> 0 OR EXISTS
    (SELECT *FROM AccountRecords R1
    WHERE R1.AID = A.AID))
    AND NOT EXISTS(SELECT *
                    FROM AccountRecords R
                    WHERE A.AID = R.AID
                    AND A.aDate = R.rdate
                    AND A.aBalance = R.rBalance
                    AND R.RID = (SELECT MAX(R2.RID)
                                 FROM AccountRecords R2
                                 WHERE R2.AID = A.AID))
  $$
LANGUAGE sql;


-------



--- Fyrir dæmi 2 ---
select '2. View DebtorStatus' as now_checking;
select 'Should return 28 debtors' as result;
select count(*)
from DebtorStatus;

--- Fyrir dæmi 4 ---

begin transaction;
  INSERT INTO Bills (PID, bDueDate, bAmount, bIsPaid) values (105, '2014-10-23', 3141, false );
  savepoint point1;

  INSERT INTO Bills (PID, bDueDate, bAmount, bIsPaid) values (106, '2020-10-23', -3141, false );
  savepoint point2;

  DELETE from Bills
  WHERE bduedate > '2013-01-01';

  savepoint point3;

  select * FROM bills;

rollback;