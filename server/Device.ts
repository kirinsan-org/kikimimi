export interface Device {
  recordedData: number[]
  detectedCommand: {
    id: string
    timestamp: number
  }
}