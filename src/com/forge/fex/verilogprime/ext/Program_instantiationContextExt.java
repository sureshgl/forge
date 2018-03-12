package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Program_instantiationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Program_instantiationContextExt extends AbstractBaseExt {

	public Program_instantiationContextExt(Program_instantiationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Program_instantiationContext getContext() {
		return (Program_instantiationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).program_instantiation());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Program_instantiationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Program_instantiationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}