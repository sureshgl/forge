package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Bind_instantiationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Bind_instantiationContextExt extends AbstractBaseExt {

	public Bind_instantiationContextExt(Bind_instantiationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Bind_instantiationContext getContext() {
		return (Bind_instantiationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).bind_instantiation());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Bind_instantiationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Bind_instantiationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}