
-- ============================================================
-- 13. SIMPLE QUERIES
-- استعلامات بسيطة لعرض البيانات وحساب متوسط الرواتب.
-- ============================================================
-- 1. أسماء الموظفين ورواتبهم
SELECT FirstName, LastName, Salary FROM Employees;
-- 2. متوسط رواتب جميع الموظفين
SELECT ROUND(AVG(Salary),2) AS AverageSalary FROM Employees;
-- 3. اسم الموظف كاملًا مع الراتب
SELECT FirstName || ' ' || LastName AS EmployeeName, Salary FROM Employees;
-- 4. أسماء الأقسام
SELECT DepartmentName FROM Departments;
-- 5. أسماء الدورات وتواريخ بدايتها
SELECT CourseName, StartDate FROM TrainingCourses;

-- ============================================================
-- 14. ADVANCED QUERIES
-- خمسة عشر استعلامًا متقدمًا حسب متطلبات المشروع؛ كل استعلام تحته شرح عربي.
-- ============================================================

-- QUERY 01: عدد الموظفين ومتوسط الرواتب في كل قسم
-- الشرح: LEFT JOIN يعرض حتى الأقسام التي ليس فيها موظفون، وGROUP BY يجمع النتائج لكل قسم.
SELECT d.DepartmentID,d.DepartmentName,COUNT(e.EmployeeID) AS EmployeeCount,
       ROUND(AVG(e.Salary),2) AS AverageSalary
FROM Departments d LEFT JOIN Employees e ON e.DepartmentID=d.DepartmentID
GROUP BY d.DepartmentID,d.DepartmentName ORDER BY d.DepartmentID;

-- QUERY 02: أسماء المدربين والدورات التي يقدمونها
-- الشرح: نربط المدرب بالدورة بواسطة InstructorID؛ قد تظهر قيمة فارغة للمدرب الذي حُذفت دورته.
SELECT i.FirstName || ' ' || i.LastName AS InstructorName,c.CourseName
FROM Instructors i LEFT JOIN TrainingCourses c ON c.InstructorID=i.InstructorID
ORDER BY i.InstructorID;

-- QUERY 03: الموظف والقسم ومتوسط راتب القسم
-- الشرح: OVER PARTITION BY يحسب المتوسط لكل قسم دون اختصار صفوف الموظفين.
SELECT e.FirstName || ' ' || e.LastName AS EmployeeName,d.DepartmentName,
       ROUND(AVG(e.Salary) OVER (PARTITION BY e.DepartmentID),2) AS DepartmentAverageSalary
FROM Employees e JOIN Departments d ON d.DepartmentID=e.DepartmentID
ORDER BY d.DepartmentID,e.EmployeeID;

-- QUERY 04: عدد الإجازات المعتمدة والمرفوضة لكل موظف
-- الشرح: CASE يحسب كل حالة على حدة؛ لا توجد إجازات مرفوضة في بيانات التكليف الأصلية.
SELECT e.EmployeeID,e.FirstName || ' ' || e.LastName AS EmployeeName,
       SUM(CASE WHEN l.Status='Approved' THEN 1 ELSE 0 END) AS ApprovedLeaves,
       SUM(CASE WHEN l.Status='Rejected' THEN 1 ELSE 0 END) AS RejectedLeaves
FROM Employees e LEFT JOIN LeaveRequests l ON l.EmployeeID=e.EmployeeID
GROUP BY e.EmployeeID,e.FirstName,e.LastName ORDER BY e.EmployeeID;

-- QUERY 05: عدد الموظفين في كل قسم
-- الشرح: COUNT يحسب الموظفين؛ LEFT JOIN يظهر الأقسام الخالية أيضًا.
SELECT d.DepartmentName,COUNT(e.EmployeeID) AS EmployeeCount
FROM Departments d LEFT JOIN Employees e ON e.DepartmentID=d.DepartmentID
GROUP BY d.DepartmentID,d.DepartmentName ORDER BY d.DepartmentID;

-- QUERY 06: اسم المدرب وعدد الدورات التي يدربها
-- الشرح: GROUP BY يجمع الدورات بحسب المدرب، ويظهر صفرًا لمن لا يملك دورة.
SELECT i.FirstName || ' ' || i.LastName AS InstructorName,COUNT(c.CourseID) AS CourseCount
FROM Instructors i LEFT JOIN TrainingCourses c ON c.InstructorID=i.InstructorID
GROUP BY i.InstructorID,i.FirstName,i.LastName ORDER BY i.InstructorID;

-- QUERY 07: أسماء الموظفين والأقسام التي يعملون فيها
-- الشرح: نستخدم الربط لعرض اسم القسم بدل رقمه.
SELECT e.FirstName || ' ' || e.LastName AS EmployeeName,d.DepartmentName
FROM Employees e LEFT JOIN Departments d ON d.DepartmentID=e.DepartmentID;

-- QUERY 08: الموظفون في الأقسام التي تضم أكثر من ثلاثة موظفين
-- الشرح: HAVING يختار الأقسام التي يتجاوز عدد موظفيها ثلاثة.
SELECT e.FirstName || ' ' || e.LastName AS EmployeeName,d.DepartmentName
FROM Employees e JOIN Departments d ON d.DepartmentID=e.DepartmentID
WHERE e.DepartmentID IN (SELECT DepartmentID FROM Employees
                         GROUP BY DepartmentID HAVING COUNT(*) > 3);

-- QUERY 09: الموظفون الذين يتطابق اسمهم مع اسم قسمهم
-- الشرح: مطابقة الاسم الأول أو الأخير أو الكامل باسم القسم؛ قد لا تظهر نتائج بهذه البيانات.
SELECT e.FirstName || ' ' || e.LastName AS EmployeeName,d.DepartmentName
FROM Employees e JOIN Departments d ON d.DepartmentID=e.DepartmentID
WHERE LOWER(d.DepartmentName) = LOWER(e.FirstName)
   OR LOWER(d.DepartmentName) = LOWER(e.LastName)
   OR LOWER(d.DepartmentName) = LOWER(e.FirstName || ' ' || e.LastName);

-- QUERY 10: الدورات التي تقدمها Sarah Johnson
-- الشرح: نربط الدورات بالمدربين ونحدد الاسم المطلوب.
SELECT c.CourseID,c.CourseName,c.StartDate,c.EndDate
FROM TrainingCourses c JOIN Instructors i ON i.InstructorID=c.InstructorID
WHERE i.FirstName='Sarah' AND i.LastName='Johnson';

-- QUERY 11: الموظفون الذين لا يوجد مدير محدد لأقسامهم
-- الشرح: المقصود هنا عدم تعيين مدير للقسم، لأن جدول الموظفين لا يحتوي على عمود مدير مباشر.
SELECT e.* FROM Employees e JOIN Departments d ON d.DepartmentID=e.DepartmentID
WHERE d.ManagerID IS NULL;

-- QUERY 12: مجموع رواتب الموظفين في كل قسم
-- الشرح: SUM يجمع الرواتب وNVL يعرض صفرًا للأقسام التي ليس فيها موظفون.
SELECT d.DepartmentName,NVL(SUM(e.Salary),0) AS TotalSalaries
FROM Departments d LEFT JOIN Employees e ON e.DepartmentID=d.DepartmentID
GROUP BY d.DepartmentID,d.DepartmentName ORDER BY d.DepartmentID;

-- QUERY 13: اسم القسم والموظف الأعلى راتبًا فيه
-- الشرح: الاستعلام الفرعي MAX يبحث عن أعلى راتب لكل قسم، ويعرض المتعادلين إن وجدوا.
SELECT d.DepartmentName,e.FirstName || ' ' || e.LastName AS EmployeeName,e.Salary
FROM Employees e JOIN Departments d ON d.DepartmentID=e.DepartmentID
WHERE e.Salary=(SELECT MAX(e2.Salary) FROM Employees e2 WHERE e2.DepartmentID=e.DepartmentID)
ORDER BY d.DepartmentID;

-- QUERY 14: عدد الدورات التي تبدأ بعد 1 ديسمبر 2023
-- الشرح: COUNT يحسب الدورات التي يبدأ تاريخها بعد التاريخ المحدد، دون تضمين يوم 1 ديسمبر نفسه.
SELECT COUNT(*) AS CoursesAfterDate FROM TrainingCourses
WHERE StartDate > DATE '2023-12-01';

-- QUERY 15: جميع الموظفين أصحاب أعلى راتب في كل قسم
-- الشرح: DENSE_RANK يعطي الترتيب الأول لكل أصحاب أعلى راتب حتى في حالة التعادل.
SELECT EmployeeID,FirstName,LastName,DepartmentID,Salary
FROM (SELECT e.*,DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
      FROM Employees e)
WHERE SalaryRank=1 ORDER BY DepartmentID,EmployeeID;

-- ============================================================
-- 15. VERIFYING THE DATA
-- التحقق من عدد الصفوف بعد التعديلات: الأقسام 9، الموظفون 9، المدربون 10، الدورات 9، الإجازات 5.
-- ============================================================
SELECT 'Departments' AS TableName,COUNT(*) AS RowCount FROM Departments
UNION ALL SELECT 'Employees',COUNT(*) FROM Employees
UNION ALL SELECT 'Instructors',COUNT(*) FROM Instructors
UNION ALL SELECT 'TrainingCourses',COUNT(*) FROM TrainingCourses
UNION ALL SELECT 'LeaveRequests',COUNT(*) FROM LeaveRequests;

-- انتهى المشروع. ملاحظة: لا تشغلي الملف مرتين على نفس الجداول دون تنظيف Schema أولًا.
