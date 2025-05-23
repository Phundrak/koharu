import { useState, useEffect } from 'react'

export function useSegmentLoader(
  segment: Uint8Array<ArrayBufferLike> | null,
  imageData: ImageBitmap | null,
  imageSrc: string | null
) {
  const [segmentCanvas, setSegmentCanvas] = useState<OffscreenCanvas | null>(
    null
  )

  useEffect(() => {
    if (!segment || !imageData) return

    const segWidth = 1024
    const segHeight = 1024

    const seg = new OffscreenCanvas(segWidth, segHeight)
    let ctx = seg.getContext('2d')
    const imgData = ctx.createImageData(segWidth, segHeight)

    for (let i = 0; i < segment.length; i++) {
      const value = segment[i]
      imgData.data[i * 4] = value // R
      imgData.data[i * 4 + 1] = value // G
      imgData.data[i * 4 + 2] = value // B
      imgData.data[i * 4 + 3] = 255 // A (Fully opaque)
    }
    ctx.putImageData(imgData, 0, 0)

    const mask = new OffscreenCanvas(imageData.width, imageData.height)
    let maskCtx = mask.getContext('2d')

    maskCtx.imageSmoothingEnabled = true

    maskCtx.drawImage(
      seg,
      0,
      0,
      segWidth,
      segHeight,
      0,
      0,
      imageData.width,
      imageData.height
    )

    setSegmentCanvas(mask)
  }, [segment, imageData])

  useEffect(() => {
    setSegmentCanvas(null)
  }, [imageSrc])

  return segmentCanvas
}
