SELECT
    'computing_duration', array_join(ARRAY_AGG(duration), ',') from member_structure_duration;