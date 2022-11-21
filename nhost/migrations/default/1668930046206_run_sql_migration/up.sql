CREATE OR REPLACE FUNCTION sync_files() RETURNS TRIGGER AS

$BODY$
BEGIN
    INSERT INTO
        public.public_files(file_id)
        VALUES(new.id);
        RETURN new;
END;
$BODY$
language plpgsql;

DROP TRIGGER IF EXISTS trig_sync_student_files ON storage.files;
CREATE TRIGGER trig_sync_student_files
     AFTER INSERT ON storage.files
     FOR EACH ROW
     WHEN (new.bucket_id = 'default')
     EXECUTE PROCEDURE sync_files();
