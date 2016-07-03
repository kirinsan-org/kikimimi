export interface Command {
  audioData: {
    [key: string]: number[]
  }
  name: string
  icon: string
  action: string
}