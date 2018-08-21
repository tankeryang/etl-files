SELECT
    'computing_duration', array_join(ARRAY_AGG(duration), ',') from rfm_duration;