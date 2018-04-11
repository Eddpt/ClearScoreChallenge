# ClearScore Challenge

This repo implements the ClearScore challenge of fetching the credit score and showing it in a donut view.

The API endpoint can be found [here](https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values).

## Requirements

Xcode 9.3 (9E145) + Swift 4.1

### Summary

I've decided to keep the implementation of the `DonutView` simple since it only had one use case at the moment. Going forward, if there was a need to customise border thickness and color or even its shadow, we could refactor it in order to allow that.

I've used a `UIVisualEffectView` for the blur effect within the `DonutView`. The trick to get a shadow on a circular view I used was to apply the `cornerRadius` equal to half of the `width` for both the Donut's root view and the visualEffects one, where the visualEffects `clipsToBounds` but the root doesn't. I then apply the shadow to the root view, using a `shadowPath`.

The `DonutView` exposes a method `func setup(with childView: UIView)` which allows its users to pass any view to be contained in.

The calculation of the maximum `width` for the contained view is the following (given that it should be a square):

```
h^2 = side^2 + side^2 = 2 * side^2 <=>
<=> side = sqrt(h^2/2) = h / sqrt(2)
```

Where `h` is the `width` of the root view (or the diameter of the circle).