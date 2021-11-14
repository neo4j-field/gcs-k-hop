MATCH (n:User)
    WHERE exists((n)-[:FOLLOWS]->())
RETURN id(n) AS id