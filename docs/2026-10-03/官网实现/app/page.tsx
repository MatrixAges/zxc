import CopyPrompt from '../components/copy_prompt'
import { docs } from '../content/docs'

export default function Home() {
	return (
		<main id='content' className='home'>
			<div className='home-intro'>
				<p className='eyebrow'>zxc / experimental / 0.0.1</p>
				<h1>A language for agents.</h1>
				<p>Code should carry its architecture.</p>
				<p>
					RX makes the flow explicit. ZX keeps business logic small and statically checkable. The compiler
					gives generated code a structure that can be read, checked, and changed.
				</p>
				<div className='action-links'>
					<CopyPrompt />
					<a href='/docs'>[ read the docs → ]</a>
				</div>
				<p className='muted'>
					Plain text: <a href='/llms.txt'>index</a> / <a href='/llms-full.txt'>full reference</a>
				</p>
			</div>
			<section className='home-section' aria-labelledby='two-files'>
				<h2 id='two-files'>Two files. Clear responsibilities.</h2>
				<div className='language-pair'>
					<div>
						<h3>.rx / orchestration</h3>
						<p>Declare modules, wire inputs and outputs, make dependencies visible.</p>
						<pre>
							<code>{`<Module>
  <Call fn="quote" in="$in" out="ctx.quote" />

  <Return value="ctx.quote" />
</Module>`}</code>
						</pre>
					</div>
					<div>
						<h3>.zx / computation</h3>
						<p>One responsibility. Explicit types. Constrained, verifiable logic.</p>
						<pre>
							<code>{`export type Input = { amount: u64; };
export type Output = { amount: u64; };

export default function (in: Input): Output {
  return { amount: in.amount };
}`}</code>
						</pre>
					</div>
				</div>
				<p className='muted'>
					RX shows the composition contract. Execution requires a host runtime; the production RX scheduler is
					not implemented.
				</p>
			</section>
			<section className='home-section' aria-labelledby='contract'>
				<h2 id='contract'>The contract</h2>
				<dl className='contract-list'>
					<div>
						<dt>Identity</dt>
						<dd>A module is its file path.</dd>
					</div>
					<div>
						<dt>Dependencies</dt>
						<dd>Explicit. Directed. Acyclic.</dd>
					</div>
					<div>
						<dt>Data</dt>
						<dd>Named inputs, outputs, and state ownership.</dd>
					</div>
					<div>
						<dt>Verification</dt>
						<dd>Static checks first. Report actual execution separately.</dd>
					</div>
				</dl>
			</section>
			<section className='home-section' aria-labelledby='read-next'>
				<h2 id='read-next'>Read only what you need</h2>
				<ol className='reading-list'>
					{docs
						.filter(doc => doc.id !== 'overview')
						.map(doc => (
							<li key={doc.id}>
								<a href={`/docs#${doc.id}`}>
									{doc.title}
									<span aria-hidden='true'>↗</span>
								</a>
							</li>
						))}
				</ol>
			</section>
			<section className='home-section' aria-labelledby='current-state'>
				<h2 id='current-state'>Small surface. Honest boundaries.</h2>
				<p>
					The ZX compiler emits Zig. RX supports module registration and dependency checks. A production RX
					runtime and database are not implemented.
				</p>
				<a href='/docs#capabilities'>Current capabilities →</a>
			</section>
		</main>
	)
}
