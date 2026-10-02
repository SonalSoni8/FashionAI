/** An error whose message is safe and useful to show to the person using the app. */
export class HttpError extends Error {
  constructor(
    public status: number,
    message: string,
  ) {
    super(message)
  }
}

export const missingKey = (name: string, what: string) =>
  new HttpError(503, `${what} is not set up yet. Add ${name} to the .env file and restart the server.`)
