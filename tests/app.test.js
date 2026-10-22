// supertest sends fake HTTP requests to the app, no real server needed.
const request = require('supertest');
const app = require('../src/app');

describe('GET /health', () => {
  it('returns status ok', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });
});

describe('GET /add', () => {
  it('adds two numbers', async () => {
    const res = await request(app).get('/add?a=2&b=3');
    expect(res.status).toBe(200);
    expect(res.body.result).toBe(5);
  });

  it('rejects non-numbers with 400', async () => {
    const res = await request(app).get('/add?a=x&b=3');
    expect(res.status).toBe(400);
  });
});
