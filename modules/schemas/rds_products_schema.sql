CREATE TABLE IF NOT EXISTS productos (
  id SERIAL PRIMARY KEY,
  nombre TEXT NOT NULL,
  stock INTEGER NOT NULL DEFAULT 0
);

INSERT INTO productos (nombre, stock)
VALUES
  ('La asistenta', 4),
  ('Platero y yo', 22),
  ('El lazarillo de tormes', 2)
ON CONFLICT DO NOTHING;