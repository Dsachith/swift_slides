## [1.0.3] - 2024-08-21

### Added

- **Dynamic Content Support:** Added support for loading carousel items dynamically from a URL or API, allowing real-time content updates.
- **Customizable Transitions:** Users can now choose from multiple transition effects (e.g., fade, zoom, rotate) between carousel items.
- **Pause on Hover/Interaction:** Auto-play pauses when the user interacts with the carousel (e.g., swiping, tapping, or hovering).
- **Looping Control:** Introduced a setting to allow/disallow infinite looping, giving users control over whether the carousel should loop indefinitely.
- **Carousel Item Builder:** Added a builder function to create custom carousel items for more complex layouts.
- **Indicator Customization:** Expanded customization options for indicators, including shapes (square, triangle), animations (bounce, scale), and positioning (top, left, right).
- **Lazy Loading for Carousel Items:** Implemented lazy loading so that only visible and adjacent items are loaded, improving performance for large carousels.
- **Accessibility Features:** Improved accessibility with ARIA roles, labels for screen readers, and better keyboard navigation support.
- **Gesture Detection:** Added gesture detection for vertical swiping and double-tap actions, allowing for additional interactions.
- **Event Callbacks:** Provided event callbacks for actions like `onItemChanged`, `onAutoPlayStart`, and `onAutoPlayStop` to respond to carousel events.

### Fixed

- **Auto-Play Wraparound Issue:** Fixed the issue where transitioning from the last item to the first was not smooth; transitions now wrap seamlessly in auto-play mode.

### Changed

- **Performance Optimization:** Optimized carousel performance for handling a large number of items or complex widgets, improving CPU and memory usage.
- **State Management Cleanup:** Cleaned up state management to ensure proper disposal of PageController and auto-play timer to prevent memory leaks.
- **Error Handling:** Improved error handling with meaningful messages for issues like empty item lists or invalid configurations.
- **Documentation:** Enhanced documentation with usage examples for advanced customization and integration.
- **Responsiveness:** Improved responsiveness for different screen sizes and orientations, including smaller screens and landscape mode.
- **Backward Compatibility:** Ensured new features and changes do not break backward compatibility for existing users.
- **Test Coverage:** Increased test coverage with unit tests for key features, including new ones.
- **Widget Composition:** Reviewed widget composition for reusable components to facilitate maintenance and extension.
- **Theming Support:** Added support for theming to adapt to different themes (light, dark) without manual customization.

## [1.0.2] - 2024-08-21

### Added

- Added seamless looping feature to the carousel for auto-play mode.
- Improved performance of the carousel's page transitions.
- Updated documentation for better clarity.

### Fixed

- Fixed an issue where the carousel would transition step-by-step in reverse after reaching the last item.

## [1.0.1] - 2024-07-30

### Added

- Auto-play feature for the carousel.
- Customizable indicators for the carousel.

## [1.0.0] - 2024-07-15

- Initial release of `swift_slides` package with basic carousel functionality.
