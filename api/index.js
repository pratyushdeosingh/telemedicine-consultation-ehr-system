const app = require('../backend/server');

module.exports = (req, res) => {
    const path = req.query.path;
    if (typeof path !== 'string' || path.length > 300 || path.includes('..')) {
        return res.status(404).json({ error: 'Not found' });
    }
    const url = new URL(req.url, 'https://local.invalid');
    url.searchParams.delete('path');
    req.url = `/api/${path}${url.search}`;
    return app(req, res);
};
