-- hack to get acas to use acas schema
ALTER USER acas SET search_path TO acas;

-- Create experiment_orders table
CREATE TABLE IF NOT EXISTS experiment_orders (
    id BIGSERIAL PRIMARY KEY,
    tracking_id VARCHAR(255) NOT NULL UNIQUE,
    project_id BIGINT NOT NULL,
    protocol_id VARCHAR(255) NOT NULL,
    experiment_type VARCHAR(255) NOT NULL,
    priority INTEGER,
    status VARCHAR(50) NOT NULL DEFAULT 'Created',
    expected_completion_date TIMESTAMP,
    submitted_by VARCHAR(255) NOT NULL,
    submitted_date TIMESTAMP NOT NULL,
    last_updated TIMESTAMP
);

-- Create experiment_samples table to link samples to experiments
CREATE TABLE IF NOT EXISTS experiment_samples (
    id SERIAL PRIMARY KEY,
    experiment_order_id INTEGER REFERENCES experiment_orders(id),
    sample_id INTEGER NOT NULL,
    sample_role VARCHAR(50),
    concentration NUMERIC,
    units VARCHAR(20)
);

-- Create indexes for common queries
CREATE INDEX idx_exp_orders_project ON experiment_orders(project_id);
CREATE INDEX idx_exp_orders_status ON experiment_orders(status);
CREATE INDEX idx_exp_orders_protocol ON experiment_orders(protocol_id);
CREATE INDEX idx_experiment_samples_order_id ON experiment_samples(experiment_order_id);

-- Add comments
COMMENT ON COLUMN experiment_orders.tracking_id IS 'Unique identifier for tracking the order';
COMMENT ON COLUMN experiment_orders.protocol_id IS 'Reference to the protocol to be run';

-- Add trigger to update last_updated timestamp
CREATE OR REPLACE FUNCTION update_experiment_last_updated()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER experiment_orders_last_updated
    BEFORE UPDATE ON experiment_orders
    FOR EACH ROW
    EXECUTE FUNCTION update_experiment_last_updated();
