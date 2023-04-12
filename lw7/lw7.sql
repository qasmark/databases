-- 1. Добавить внешние ключи.
ALTER TABLE lesson
    ADD CONSTRAINT lesson_teacher_id_teacher_fk
        FOREIGN KEY (id_teacher) REFERENCES teacher (id_teacher)
            ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE lesson
    ADD CONSTRAINT lesson_subject_id_subject_fk
        FOREIGN KEY (id_subject) REFERENCES subject (id_subject)
            ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE lesson
    ADD CONSTRAINT lesson_group_id_group_fk
        FOREIGN KEY (id_group) REFERENCES [group](id_group)
            ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE mark
    ADD CONSTRAINT mark_lesson_id_lesson_fk
        FOREIGN KEY (id_lesson) REFERENCES lesson (id_lesson)
            ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE mark
    ADD CONSTRAINT mark_student_id_student_fk
        FOREIGN KEY (id_student) REFERENCES student (id_student)
            ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE student
    ADD CONSTRAINT student_group_id_group_fk
        FOREIGN KEY (id_group) REFERENCES [group](id_group)
            ON UPDATE CASCADE ON DELETE CASCADE;

-- 2. Выдать оценки студентов по информатике если они обучаются данному
-- предмету. Оформить выдачу данных с использованием view.
IF OBJECT_ID('informatics_marks', 'V') IS NOT NULL
    DROP VIEW informatics_marks
GO

CREATE VIEW informatics_marks AS
SELECT st.[name] AS student_name, m.[mark] AS mark
FROM [student] st
         INNER JOIN mark m ON st.id_student = m.id_student
         INNER JOIN lesson l ON m.id_lesson = l.id_lesson
         INNER JOIN subject sj ON l.id_subject = sj.id_subject AND sj.[name] = 'Информатика'
GO

SELECT *
FROM informatics_marks
ORDER BY 1;


-- 3. Дать информацию о должниках с указанием фамилии студента и названия
-- предмета. Должниками считаются студенты, не имеющие оценки по предмету,
-- который ведется в группе. Оформить в виде процедуры, на входе
-- идентификатор группы.
IF OBJECT_ID('get_dummy_students', 'P') IS NOT NULL
    DROP PROCEDURE get_dummy_students;
GO

CREATE PROCEDURE get_dummy_students
    @group_name VARCHAR(10)
AS
BEGIN
    SELECT DISTINCT st.[name], sj.[name]
    FROM [student] st
             INNER JOIN [group] g ON st.id_group = g.id_group AND g.[name] = @group_name
             INNER JOIN lesson l ON g.id_group = l.id_group
             INNER JOIN subject sj ON l.id_subject = sj.id_subject
             LEFT JOIN mark m ON st.id_student = m.id_student AND l.id_lesson = m.id_lesson
    WHERE m.id_mark IS NULL;
END;
GO

EXEC get_dummy_students 'ПС';

-- 4. Дать среднюю оценку студентов по каждому предмету для тех предметов, по
-- которым занимается не менее 35 студентов.

CREATE TABLE #subject_student_quantity(id_subject int, subject_name nvarchar(50), student_quantity int, subject_average_mark smallint);
INSERT INTO #subject_student_quantity
  SELECT subject.id_subject, subject.name, COUNT(student.id_student), AVG(mark.mark) FROM subject
  LEFT JOIN lesson ON [subject].id_subject = lesson.id_subject
  LEFT JOIN [group] ON lesson.id_group = [group].id_group
  LEFT JOIN student ON [group].id_group = student.id_group
  LEFT JOIN mark ON lesson.id_lesson = mark.id_lesson
  WHERE student.id_student IS NOT NULL
  GROUP BY subject.id_subject, subject.name;

SELECT subject_name, subject_average_mark FROM #subject_student_quantity WHERE student_quantity >= 35;

-- 5. Дать оценки студентов специальности ВМ по всем проводимым предметам с
-- указанием группы, фамилии, предмета, даты. При отсутствии оценки заполнить
-- значениями NULL поля оценки.
SELECT st.name AS student, sj.name AS subject, l.date AS date, m.mark AS mark
FROM student st
         INNER JOIN [group] g ON st.id_group = g.id_group AND g.name = 'ВМ'
         INNER JOIN lesson l ON g.id_group = l.id_group
         INNER JOIN subject sj ON l.id_subject = sj.id_subject
         LEFT JOIN mark m ON st.id_student = m.id_student AND l.id_lesson = m.id_lesson
ORDER BY 1;

-- 6. Всем студентам специальности ПС, получившим оценки меньшие 5 по предмету
-- БД до 12.05, повысить эти оценки на 1 балл.
SELECT * FROM [group]
  LEFT JOIN lesson ON [group].id_group = lesson.id_group
  LEFT JOIN mark ON mark.id_lesson = lesson.id_lesson
  WHERE [group].name = 'ПС' AND mark.mark < 5 AND lesson.date < '12.05.2019';

UPDATE mark SET mark.mark = mark.mark + 1 FROM [group]
  LEFT JOIN lesson ON [group].id_group = lesson.id_group
  LEFT JOIN mark ON mark.id_lesson = lesson.id_lesson
  WHERE [group].name = 'ПС' AND mark.mark < 5 AND lesson.date < '12.05.2019';

-- 7. Добавить необходимые индексы
CREATE INDEX IX_subject_name ON subject (name);
CREATE INDEX IX_mark_mark ON mark (mark);
CREATE INDEX IX_group_id_group ON [group] (id_group);
CREATE INDEX IX_student_id_student ON student (id_student);
CREATE INDEX IX_group_name ON [group] (name);
CREATE INDEX IX_lesson_date ON lesson (date);