package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Structure_pattern_keyContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Structure_pattern_keyContextExt extends AbstractBaseExt {

	public Structure_pattern_keyContextExt(Structure_pattern_keyContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Structure_pattern_keyContext getContext() {
		return (Structure_pattern_keyContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).structure_pattern_key());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Structure_pattern_keyContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Structure_pattern_keyContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}