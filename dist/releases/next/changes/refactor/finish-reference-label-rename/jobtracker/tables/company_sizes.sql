-- liquibase formatted sql
-- changeset JOBTRACKER:1793725877752 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:e82a04bf833faaa5619fe50324fb833389483b80:60c5bcefca578cf2e5d5dc693ca4298a58c1ee20:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_SIZES" DROP ("COMPANY_SIZE_SHORT_NAME")
/
*/

-- changeset JOBTRACKER:1793725877767 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:e82a04bf833faaa5619fe50324fb833389483b80:99475d896f71401551985c85f48e139eb31cacc4:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_SIZES" DROP ("COMPANY_SIZE_LONG_NAME")
/
*/

-- changeset JOBTRACKER:1793725877783 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:e82a04bf833faaa5619fe50324fb833389483b80:c1a125a824d0667dbbcf696a63b94481e8955841:alter

alter table jobtracker.company_sizes modify (
    company_size_short_name_en not null enable
)
/

-- changeset JOBTRACKER:1793725877795 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:e82a04bf833faaa5619fe50324fb833389483b80:40ac161f71f3ef6e42d9b4f5290be90762fbefe3:alter

alter table jobtracker.company_sizes modify (
    company_size_long_name_en not null enable
)
/

-- changeset JOBTRACKER:1793725877802 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:e82a04bf833faaa5619fe50324fb833389483b80:50d4ba6cabcb6e67655fcbf38acf20404bbedadd:alter

alter table jobtracker.company_sizes modify (
    company_size_short_name_fr not null enable
)
/

-- changeset JOBTRACKER:1793725877806 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:e82a04bf833faaa5619fe50324fb833389483b80:c84d2592825583d91959a7e5fc4c63f0204396fc:alter

alter table jobtracker.company_sizes modify (
    company_size_long_name_fr not null enable
)
/

-- changeset JOBTRACKER:1793725877809 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:e82a04bf833faaa5619fe50324fb833389483b80:72f5b7aec81e5c4852075ebba506627bfdd9f093:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_SIZES" DROP CONSTRAINT "COMPANY_SIZES_COMPANY_SIZE_SHORT_NAME_UK"
/
*/

-- changeset JOBTRACKER:1793725877811 stripComments:false  logicalFilePath:refactor/finish-reference-label-rename/jobtracker/tables/company_sizes.sql
-- sqlcl_snapshot src/database/jobtracker/tables/company_sizes.sql:e82a04bf833faaa5619fe50324fb833389483b80:6ed8868554db816a68f0bc2be282b480c13b826e:alter

/*  Uncomment drop statement after ensuring it is performing the correct actions
ALTER TABLE "JOBTRACKER"."COMPANY_SIZES" DROP CONSTRAINT "COMPANY_SIZES_COMPANY_SIZE_LONG_NAME_UK"
/
*/

