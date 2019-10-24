import { LightningElement, api, track } from 'lwc';

export default class Modal extends LightningElement {

    @api loading = false;
    @track modalClasses = 'slds-modal';

    /**
     * @param {'large' | 'medium' | 'small' | undefined} value
     */
    @api set size(value) {
        if (value === 'small') value = undefined;
        this._size = value;
        if (this.modal) this.setModalSize();
    }

    get size() {
        return this._size;
    }

    renderedCallback() {
        if (!this.hasRendered) {
            const style = document.createElement('style');
            // language=CSS
            style.innerText = `
                c-modal .slds-modal__close svg {
                    fill: white;
                }
            `;
            style.setAttribute('type', 'text/css');
            this.modal.appendChild(style);
            this.setModalSize();
        }
        this.hasRendered = true;

        let maxHeight = ['100%', this.header.scrollHeight + 'px', this.footer.scrollHeight + 'px'];
        maxHeight = `calc(${maxHeight.join(' - ')})`;

        this.body.style.maxHeight = maxHeight;
    }

    @api set modal(value) {}
    get modal() {
        return this.template.querySelector('.slds-modal');
    }

    @api set backdrop(value) {}
    get backdrop() {
        return this.template.querySelector('.slds-backdrop');
    }

    get header() {
        return this.template.querySelector('.slds-modal__header');
    }

    get body() {
        return this.template.querySelector('.slds-modal__content');
    }

    get footer() {
        return this.template.querySelector('.slds-modal__footer');
    }

    @api open() {
        this.toggle(true);
    }

    @api close() {
        this.toggle(false);
    }

    @api set visible(value) {
        this.toggle(value);
    }

    get visible() {
        return this.modal.classList.contains('slds-fade-in-open');
    }

    @api toggle(show = !this.visible) {
        const action = show ? 'add' : 'remove';
        this.modal.classList[action]('slds-fade-in-open');
        this.backdrop.classList[action]('slds-backdrop_open');
        this.dispatchEvent(new CustomEvent(show ? 'open' : 'close'));
    }

    setModalSize() {
        this.modal.classList.remove('slds-modal_large', 'slds-modal_medium');
        if (this.size && this.modal) this.modal.classList.add('slds-modal_' + this.size);
    }
}