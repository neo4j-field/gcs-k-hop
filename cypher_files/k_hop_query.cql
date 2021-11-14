UNWIND $rows AS row
WITH row.id AS id
CALL {
  WITH id
  MATCH (n:User) WHERE id(n)=id
  CALL apoc.path.subgraphAll(n, {
      maxLevel: 2,
      limit: 10
  })
  YIELD nodes, relationships
  WITH n,
  [rel in relationships | rel {type: type(rel)}] as types,
  [rel in relationships | rel {fromNode: labels(startNode(rel))[0] + ":" + apoc.convert.toString(startNode(rel).id)}] as starts,
  [rel in relationships | rel {toNode: labels(endNode(rel))[0] + ":" + apoc.convert.toString(endNode(rel).id)}] as ends
  RETURN n.id AS vertex,
  [t in types | t.type] AS edgeType,
  [s in starts | s.fromNode] AS source,
  [e in ends | e.toNode] AS destinations
}
RETURN vertex, edgeType, source, destinations