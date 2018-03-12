package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Module_path_concatenationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Module_path_concatenationContextExt extends AbstractBaseExt {

	public Module_path_concatenationContextExt(Module_path_concatenationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Module_path_concatenationContext getContext() {
		return (Module_path_concatenationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).module_path_concatenation());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Module_path_concatenationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Module_path_concatenationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}